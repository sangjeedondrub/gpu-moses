#include <sstream>
#include "TargetPhrases.h"
#include "itoa.h"

using namespace std;

TargetPhrases::~TargetPhrases()
{
  for (size_t i = 0; i < m_vec.GetSize(); ++i) {
    const TargetPhrase *tp = m_vec.Get(i);
    delete tp;
  }
}

void TargetPhrases::Add(const TargetPhrase *tp)
{
	m_vec.push_back(tp);
}

__host__ std::string TargetPhrases::Debug() const
{
  stringstream strm;

  for (size_t i = 0; i < m_vec.GetSize(); ++i) {
    const TargetPhrase *tp = m_vec.Get(i);
    strm << tp->Debug() << endl;
  }
  return strm.str();
}

__device__ void MemCpy(char *dest, const char *src, size_t count)
{
  for (size_t i = 0; i < count; ++i) {
    dest[i] = src[i];
  }
}

__device__ void StrCpy(char *dest, const char *src)
{
  size_t len = strlenDevice(src);
  MemCpy(dest, src, len + 1);
}
__global__ void checkTargetPhrases(char *str, const TargetPhrases &tps)
{
  size_t size = tps.size();
  char *tmp = itoaDevice(size);

  StrCpy(str, tmp);
}

