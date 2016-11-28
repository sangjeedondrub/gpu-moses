#include "Hypothesis.h"

void Hypothesis::Init(Manager &mgr, const TargetPhrase &tp)
{
	m_mgr = &mgr;
	m_targetPhrase = &tp;
}

