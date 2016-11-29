#include "TargetPhrases.h"

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
