#include <sstream>
#include "TargetPhrase.h"
#include "MyVocab.h"

using namespace std;

TargetPhrase *TargetPhrase::CreateFromString(const std::string &str)
{
	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();
	vector<VOCABID> ids = vocab.GetOrCreateIds(str);
        cerr << "ids=" << ids.size() << endl;
	TargetPhrase *tp = new TargetPhrase(ids);
	return tp;
}

TargetPhrase::TargetPhrase(const std::vector<VOCABID> &ids)
:Phrase(ids)
,m_scores(4)
{
}

__host__ std::string TargetPhrase::Debug() const
{
  stringstream strm;
  //strm << Phrase::Debug() << " Scores:" << m_scores.Debug();

  return strm.str();
}
