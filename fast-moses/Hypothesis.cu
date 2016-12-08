#include "Hypothesis.h"
#include "Bitmap.h"
#include "Phrase.h"
#include "Manager.h"

__device__
Hypothesis::Hypothesis(const Manager &mgr)
:m_mgr(&mgr)
,m_bitmap(mgr.GetInput().size())
{
}

  __device__
void Hypothesis::Init(const Manager &mgr)
{
  m_mgr = &mgr;
  m_prevHypo = NULL;
  m_targetPhrase = NULL;

  m_bitmap.Init();
}


  __device__
void Hypothesis::Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp)
{
	m_mgr = &mgr;
	m_prevHypo = &prevHypo;
	m_targetPhrase = &tp;

  m_bitmap.Init();
}

