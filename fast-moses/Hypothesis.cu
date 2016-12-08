#include "Hypothesis.h"

void Hypothesis::Init(const Manager &mgr)
{
  m_mgr = &mgr;
}


void Hypothesis::Init(const Manager &mgr, const TargetPhrase &tp)
{
	m_mgr = &mgr;
	m_targetPhrase = &tp;
}

