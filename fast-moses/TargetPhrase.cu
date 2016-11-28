#include "TargetPhrase.cuh"
#include "MyVocab.h"

using namespace std;

TargetPhrase *TargetPhrase::CreateFromString(const std::string &str)
{
	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();
	vector<VOCABID> targetIds = vocab.GetOrCreateIds(str);
	TargetPhrase *tp = new TargetPhrase(targetIds);
	return tp;
}

TargetPhrase::TargetPhrase(const std::vector<VOCABID> &targetIds)
:Phrase(targetIds.size())
//,m_scores(4)
{
	for (size_t i = 0; i < targetIds.size(); ++i) {
		m_vec[i] = targetIds[i];
	}

}
