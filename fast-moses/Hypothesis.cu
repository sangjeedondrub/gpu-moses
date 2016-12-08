#include "Hypothesis.h"

  __device__
void Hypothesis::Init(const Manager &mgr)
{
  m_mgr = &mgr;
}


  __device__
void Hypothesis::Init(const Manager &mgr, const TargetPhrase &tp)
{
	m_mgr = &mgr;
	m_targetPhrase = &tp;
}

