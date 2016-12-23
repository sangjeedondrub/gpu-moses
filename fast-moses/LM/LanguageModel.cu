#include "LanguageModel.h"
#include "MyVocab.h"
#include "../Util.h"
#include "../InputFileStream.h"
#include "../ScoresUnmanaged.h"
#include "../Hypothesis.h"
#include "../Manager.h"
#include "../CUDA/Array.h"

using namespace std;

LanguageModel::LanguageModel(size_t startInd, const std::string &line)
:StatefulFeatureFunction(startInd, line)
,m_unkScores(false, 123, 456)
,m_root(m_unkScores)
{
  classId = FeatureFunction::ClassId::LanguageModel;

  ReadParameters();
}

LanguageModel::~LanguageModel()
{

}

void LanguageModel::SetParameter(const std::string& key,
    const std::string& value)
{
  if (key == "path") {
    m_path = value;
  }
  else if (key == "factor") {
    m_factorType = Scan<FactorType>(value);
  }
  else if (key == "order") {
    m_order = Scan<size_t>(value);
  }
  else {
    StatefulFeatureFunction::SetParameter(key, value);
  }
}

void LanguageModel::Load(System &system)
{
  FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();

  m_bos = vocab.GetOrCreateId(BOS_);
  m_eos = vocab.GetOrCreateId(EOS_);

  InputFileStream infile(m_path);
  size_t lineNum = 0;
  string line;
  while (getline(infile, line)) {
    if (++lineNum % 10000 == 0) {
      cerr << lineNum << " ";
    }

    vector<string> substrings = Tokenize(line, "\t");

    if (substrings.size() < 2) continue;

    assert(substrings.size() == 2 || substrings.size() == 3);

    SCORE prob = TransformLMScore(Scan<SCORE>(substrings[0]));
    if (substrings[1] == "<unk>") {
      m_oov = prob;
      continue;
    }

    SCORE backoff = 0.f;
    if (substrings.size() == 3) {
      backoff = TransformLMScore(Scan<SCORE>(substrings[2]));
    }

    // ngram
    vector<VOCABID> factorKey = vocab.GetOrCreateIds(substrings[1]);
    std::reverse(factorKey.begin(), factorKey.end());
    Node<LMScores> &node = m_root.AddOrCreateNode(factorKey, m_unkScores);
    node.value = LMScores(true, prob, backoff);

  }
}

void LanguageModel::EvaluateInIsolation(
    const System &system,
    const Phrase &source,
    const TargetPhrase &targetPhrase,
    Scores &scores,
    SCORE &estimatedScore) const
{

}

__device__
void LanguageModel::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  Array<VOCABID> context(m_order);
  context.resize(0);

  // prev words
  int targetPos = (int) hypo.currTargetWordsRange.startPos - 1;
  while (context.size() < m_order && targetPos >= 0) {
    VOCABID vocabId = hypo.GetWord(targetPos);
    context.push_back(vocabId);
    --targetPos;
  }

  // score each ngram
  SCORE score = 0;
  thrust::pair<SCORE, void*> fromScoring;
  const TargetPhrase &tp = *hypo.targetPhrase;
  for (size_t i = 0; i < tp.size(); ++i) {
    VOCABID vocabId = tp[i];
    ShiftOrPush(context, vocabId);
    fromScoring = Score(context);
    score += fromScoring.first;
  }

  const Bitmap &bm = hypo.bitmap;
  if (bm.IsComplete()) {
    // everything translated
    ShiftOrPush(context, m_eos);
    fromScoring = Score(context);
    score += fromScoring.first;
    fromScoring.second = NULL;
  }

  ScoresUnmanaged &scores = hypo.scores;
  scores.PlusEqual(mgr.system, *this, score);

  // state info

}

__device__
void LanguageModel::ShiftOrPush(Array<VOCABID> &context, VOCABID vocabId) const
{
  if (context.size() < m_order) {
    context.resize(context.size() + 1);
  }

  for (size_t i = context.size() - 1; i > 0; --i) {
    context[i] = context[i - 1];
  }

  context[0] = vocabId;

}

__device__
thrust::pair<SCORE, void*> LanguageModel::Score(
    const Array<VOCABID> &context) const
{
  thrust::pair<SCORE, void*> ret(0, NULL);

  if (context.size() == 0) {
    return ret;
  }

  typedef Node<LMScores> LMNode;
  const LMNode *node = m_root.Lookup(context, 0);
  if (node && node->value.found) {
    ret.first = node->value.prob;
    ret.second = (void*) node;
  }
  else {
    SCORE backoff = 0;

    Array<VOCABID> backOffContext(context.size() - 1);
    for (size_t i = 1; i < context.size(); ++i) {
      backOffContext[i - 1] = context[i];
    }

    node = m_root.Lookup(backOffContext, 0);
    if (node && node->value.found) {
      backoff = node->value.backoff;
    }

    Array<VOCABID> newContext(context.size() - 1);
    for (size_t i = 0; i < context.size() - 1; ++i) {
      newContext[i] = context[i];
    }

    thrust::pair<SCORE, void*> newRet = Score(newContext);

    ret.first = backoff + newRet.first;
    ret.second = newRet.second;

  }

  return ret;
}

