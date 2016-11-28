#include "TargetPhrase.h"
#include "MyVocab.h"

using namespace std;

TargetPhrase *TargetPhrase::CreateFromString(const std::string &str)
{
	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();
	vector<VOCABID> ids = vocab.GetOrCreateIds(str);
	TargetPhrase *tp = new TargetPhrase(ids);
	return tp;
}

TargetPhrase::TargetPhrase(const std::vector<VOCABID> &ids)
:Phrase(ids)
,m_scores(4)
{
}
