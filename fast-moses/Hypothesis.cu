#include "Hypothesis.h"
#include "Bitmap.h"
#include "Phrase.h"
#include "TargetPhrase.h"
#include "Manager.h"
#include "System.h"

__device__
Hypothesis::Hypothesis(const Manager &mgr)
:m_mgr(&mgr)
,m_bitmap(mgr.GetInput().size())
,m_scores(4)
{
   sss = mgr.system.ffs.totalSize;
   stateData = (char*) malloc(mgr.system.ffs.totalSize);
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

__global__
void getTotalScore(const Hypothesis &hypo, SCORE &output)
{
  output = hypo.GetScores().GetTotal();
  //output = hypo.sss; //score;
  //output = 456.789;
}

__host__
SCORE Hypothesis::GetFutureScore() const
{
    SCORE *d_s;
    cudaMalloc(&d_s, sizeof(SCORE));
    cudaDeviceSynchronize();

    getTotalScore<<<1,1>>>(*this, *d_s);
    cudaDeviceSynchronize();
    
    SCORE h_s;
    cudaMemcpy(&h_s, d_s, sizeof(SCORE), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    
    return h_s;
}

