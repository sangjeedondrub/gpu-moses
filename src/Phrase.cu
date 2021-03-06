#include <sstream>
#include <vector>
#include "Phrase.h"
#include "MyVocab.h"
#include "CUDA/Util.h"

using namespace std;

Phrase *Phrase::CreateFromString(const std::string &str)
{
	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();
	vector<VOCABID> ids = vocab.GetOrCreateIds(str);
	Phrase *tp = new Phrase(ids);
	return tp;
}

__host__
Phrase::Phrase(size_t size)
:m_vec(size)
{

}

__host__ Phrase::Phrase(const std::vector<VOCABID> &ids)
:m_vec(ids.size())
{
	//cudaDeviceSynchronize();
	//cerr << "GetSize()=" << m_vec->GetSize() << endl;
	for (size_t i = 0; i < ids.size(); ++i) {
	    //cerr << i << "=" << ids[i] << endl;
  	    //m_vec.Set(i, ids[i]);
  	    m_vec[i] = ids[i];
	}
	//cudaDeviceSynchronize();
}

__host__ std::string Phrase::Debug() const
{
  return m_vec.Debug();
}


__global__ void checkPhrase(char *str, const Phrase &phrase)
{
  size_t size = phrase.size();
  size_t totVocabId = size;
  for (size_t i = 0; i < size; ++i) {
    VOCABID id = phrase[i];
    totVocabId += id;
  }

  char *tmp = itoaDevice(totVocabId);
  StrCpy(str, tmp);

  //cudaMemcpy(&totVocabId, &sum, sizeof(VOCABID), cudaMemcpyDeviceToHost);                                             
}

