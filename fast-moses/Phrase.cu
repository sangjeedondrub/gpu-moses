#include <sstream>
#include <vector>
#include "Phrase.h"
#include "MyVocab.h"

using namespace std;

Phrase *Phrase::CreateFromString(const std::string &str)
{
	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();
	vector<VOCABID> ids = vocab.GetOrCreateIds(str);
	Phrase *tp = new Phrase(ids);
	return tp;
}

Phrase::Phrase(const std::vector<VOCABID> &ids)
:m_vec(ids.size())
{
	for (size_t i = 0; i < ids.size(); ++i) {
		m_vec.Set(i, ids[i]);
	}
}

std::string Phrase::Debug() const
{
	stringstream strm;
	for (size_t i = 0; i < m_vec.size(); ++i) {
		strm << m_vec.Get(i) << " ";
	}
	return strm.str();
}
