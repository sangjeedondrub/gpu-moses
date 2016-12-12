#include "Distortion.h"
#include "../Hypothesis.h"

Distortion::Distortion()
{
	stateSize = sizeof(size_t);
}

__device__
void Distortion::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo)
{
  ScoresUnmanaged &scores = hypo.scores;

}
