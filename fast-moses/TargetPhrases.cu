#include <sstream>
#include "TargetPhrases.h"

using namespace std;

TargetPhrases::~TargetPhrases()
{
  for (size_t i = 0; i < m_vec.size(); ++i) {
    const TargetPhrase *tp = m_vec[i];
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

  for (size_t i = 0; i < m_vec.size(); ++i) {
    const TargetPhrase *tp = m_vec[i];
    strm << tp->Debug() << endl;
  }
  return strm.str();
}
