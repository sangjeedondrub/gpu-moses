#include <sstream>
#include "Hypothesis.h"
#include "Bitmap.h"
#include "Phrase.h"
#include "TargetPhrase.h"
#include "Manager.h"
#include "System.h"
#include "CUDA/Util.h"

using namespace std;

__device__
Hypothesis::Hypothesis(const Manager &mgr)
:mgr(&mgr)
,bitmap(mgr.GetInput().size())
,scores(mgr.system.featureFunctions.totalNumScores)
,stateData(mgr.system.featureFunctions.totalStateSize)
{
  sss = 453.54;
}

  __device__
void Hypothesis::Init(const Manager &mgr)
{
  this->mgr = &mgr;
  prevHypo = NULL;

  path = &mgr.initPath;
  targetPhrase = &mgr.initPhrase;

  bitmap.Init();
}


__device__
void Hypothesis::Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp, const InputPath &path)
{
  this->mgr = &mgr;
  this->prevHypo = &prevHypo;

  this->path = &path;
  targetPhrase = &tp;

  const Bitmap &prevBM = prevHypo.bitmap;
  bitmap.Init(prevBM, path.range);

  scores.PlusEqual(mgr.system, tp.GetScores());
  scores.PlusEqual(mgr.system, prevHypo.scores);

  mgr.system.featureFunctions.EvaluateWhenApplied(mgr, *this);
}

__device__
SCORE Hypothesis::getFutureScore() const
{
  return scores.GetTotal();
}

__device__
int Hypothesis::RecombineCompare(const Hypothesis &other) const
{
  // -1 = this < compare
  // +1 = this > compare
  // 0  = this ==compare
  int comp = bitmap.Compare(other.bitmap);
  if (comp != 0)
    return comp;

  return stateData.Compare(other.stateData);
}

__global__
void getTotalScore(const Hypothesis &hypo, SCORE &output)
{
  output = hypo.getFutureScore();
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
    
    cudaFree(d_s);

    return h_s;
}

///////////////////////////////////////////////////////////////
__host__
std::string Hypothesis::Debug() const
{
  stringstream strm;
  strm << this << " ";

  char *d_str;
  cudaMallocManaged(&d_str, 1000);
  cudaDeviceSynchronize();
  cudaMemset(d_str, 0, 1000);

  debugObj<<<1,1>>>(*this, d_str);
  cudaDeviceSynchronize();

  strm << d_str;

  cudaFree(d_str);

  return strm.str();;
}

__device__
void Hypothesis::Debug(char *out) const
{
  path->range.Debug(out);
  StrCat(out, " ");
  bitmap.Debug(out);
  StrCat(out, " ");
  scores.Debug(out);

  if (prevHypo) {
    StrCat(out, "\n");
    prevHypo->Debug(out);
  }
}

