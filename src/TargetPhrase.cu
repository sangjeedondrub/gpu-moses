#include <sstream>
#include "TargetPhrase.h"
#include "MyVocab.h"
#include "System.h"
#include "CUDA/Util.h"

#include "TypeDef.h"

using namespace std;

TargetPhrase *TargetPhrase::CreateFromString(const System &sys, const std::string &str)
{
	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();
	vector<VOCABID> ids = vocab.GetOrCreateIds(str);
  //cerr << "ids=" << ids.size() << endl;

	TargetPhrase *tp = new TargetPhrase(sys, ids);
	return tp;
}

__host__
TargetPhrase::TargetPhrase(const System &sys, size_t size)
:Phrase(size)
,m_scores(sys.featureFunctions.totalNumScores)
{

}

TargetPhrase::TargetPhrase(const System &sys, const std::vector<VOCABID> &ids)
:Phrase(ids)
,m_scores(sys.featureFunctions.totalNumScores)
{
}

__host__ std::string TargetPhrase::Debug() const
{
  stringstream strm;
  strm << Phrase::Debug() << " Scores:" << m_scores.Debug();

  return strm.str();
}

__global__ void checkTargetPhrase(char *str, const TargetPhrase &phrase)
{
  VOCABID totVocabId;
  SCORE totScore;

  size_t size = phrase.size();
  totVocabId = size;
  for (size_t i = 0; i < size; ++i) {
    VOCABID id = phrase[i];
    totVocabId += id;
  }

  size = phrase.GetScores().size();
  totScore = size;
  for (size_t i = 0; i < size; ++i) {
      SCORE score = phrase.GetScores()[i];
      totScore += score;
  }

  char *tmp = itoaDevice(totVocabId + totScore);
  StrCpy(str, tmp);

}

