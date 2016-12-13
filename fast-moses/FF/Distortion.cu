#include "Distortion.h"
#include "../Hypothesis.h"
#include "../Range.h"
#include "../InputPath.h"

Distortion::Distortion()
{
	stateSize = sizeof(size_t);
	startInd = 4;
	numScores = 1;
}

__device__
void Distortion::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{

  if (hypo.prevHypo) {
    const Range &prevRange = hypo.prevHypo->path->range;
    const Range &currRange = hypo.path->range;

    int dist = ComputeDistortionDistance(prevRange, currRange);

    ScoresUnmanaged &scores = hypo.scores;

    scores.PlusEqual(*this, currRange.startPos + currRange.endPos);
    //scores.PlusEqual(*this, dist);
  }

}

__device__
int Distortion::ComputeDistortionDistance(const Range& prev,
    const Range& current) const
{
  int dist = 0;
  if (prev.GetNumWordsCovered() == 0) {
    dist = current.startPos;
  }
  else {
    dist = (int) prev.endPos - (int) current.startPos + 1;
  }
  return abs(dist);
}
