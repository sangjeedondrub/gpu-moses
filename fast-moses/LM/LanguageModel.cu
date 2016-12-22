#include "LanguageModel.h"
#include "MyVocab.h"
#include "../Util.h"
#include "../InputFileStream.h"

using namespace std;

LanguageModel::LanguageModel(size_t startInd, const std::string &line)
:StatefulFeatureFunction(startInd, line)
,m_unkScores(false, 99999, 999999)
,m_root(m_unkScores)
{

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

  InputFileStream infile(m_path);
  size_t lineNum = 0;
  string line;
  while (getline(infile, line)) {
    if (++lineNum % 100000 == 0) {
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

