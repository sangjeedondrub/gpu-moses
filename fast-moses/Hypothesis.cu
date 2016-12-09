#include "Hypothesis.h"
#include "Bitmap.h"
#include "Phrase.h"
#include "Manager.h"
#include "TargetPhrase.h"

__device__
Hypothesis::Hypothesis(const Manager &mgr)
:m_mgr(&mgr)
,m_bitmap(mgr.GetInput().size())
,m_scores(4)
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
void Hypothesis::Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp, const Range &range)
{
	m_mgr = &mgr;
	m_prevHypo = &prevHypo;
	m_targetPhrase = &tp;

	const Bitmap &prevBM = prevHypo.GetBitmap();
  m_bitmap.Init(prevBM, range);

  m_scores.PlusEqual(tp.GetScores());
  m_scores.PlusEqual(prevHypo.m_scores);
}

__host__
SCORE Hypothesis::GetFutureScore() const
{
  return 343.4;
}

SCORE Hypothesis::GetTotalScore(const Hypothesis *hypo)
{
  return 88.55;
}

