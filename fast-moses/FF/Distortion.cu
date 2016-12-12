#include "Distortion.h"
#include "../Hypothesis.h"
#include "../Range.h"

Distortion::Distortion()
{
	stateSize = sizeof(size_t);
}

__device__
void Distortion::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  ScoresUnmanaged &scores = hypo.scores;

  //const Range &currRange = hypo.
}

__device__
int Distortion::ComputeDistortionDistance(const Range& prev,
    const Range& current) const
{
  int dist = 0;
  if (prev.GetNumWordsCovered() == 0) {
    dist = current.GetStartPos();
  }
  else {
    dist = (int) prev.GetEndPos() - (int) current.GetStartPos() + 1;
  }
  return abs(dist);
}
