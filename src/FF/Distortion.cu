#include "Distortion.h"
#include "../Hypothesis.h"
#include "../Range.h"
#include "../InputPath.h"
#include "../Manager.h"

Distortion::Distortion(size_t startInd, const std::string &line)
:StatefulFeatureFunction(startInd, line)
{
  classId = FeatureFunction::ClassId::Distortion;
	stateSize = sizeof(size_t);

	ReadParameters();
}

__device__
void Distortion::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{

  if (hypo.prevHypo == NULL) {
    return;
  }

  // score
  const Range &prevRange = hypo.prevHypo->path->range;
  const Range &currRange = hypo.path->range;

  int dist = - ComputeDistortionDistance(prevRange, currRange);

  ScoresUnmanaged &scores = hypo.scores;

  //scores.PlusEqual(*this, currRange.startPos + currRange.endPos);
  scores.PlusEqual(mgr.system, *this, dist);

  const size_t &endPos = currRange.endPos;
  SetState(hypo, (const char*) &endPos);
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
