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
	//cudaDeviceSynchronize();
	//cerr << "GetSize()=" << m_vec->GetSize() << endl;
	for (size_t i = 0; i < ids.size(); ++i) {
	    //cerr << i << "=" << ids[i] << endl;
  	    m_vec.Set(i, ids[i]);
	}
	//cudaDeviceSynchronize();
}

__host__ std::string Phrase::Debug() const
{
  return m_vec.Debug();
}
