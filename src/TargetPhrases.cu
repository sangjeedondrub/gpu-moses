#include <sstream>
#include "TargetPhrases.h"
#include "CUDA/Util.h"

using namespace std;

TargetPhrases::TargetPhrases()
:m_vec(0)
{
}

TargetPhrases::~TargetPhrases()
{
  for (size_t i = 0; i < m_vec.size(); ++i) {
    const TargetPhrase *tp = m_vec[i];
    delete tp;
  }
}

void TargetPhrases::Add(const TargetPhrase *tp)
{
	m_vec.PushBack(tp);
}

__host__ std::string TargetPhrases::Debug() const
{
  stringstream strm;

  for (size_t i = 0; i < m_vec.size(); ++i) {
    const TargetPhrase *tp = m_vec[i];
    strm << tp->Debug() << endl;
  }
  return strm.str();
}

__global__ void checkTargetPhrases(char *str, const TargetPhrases &tps)
{
  size_t size = tps.size();
  char *tmp = itoaDevice(size);

  StrCpy(str, tmp);
}

