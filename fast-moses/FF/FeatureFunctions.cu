/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#include "FeatureFunctions.h"
#include "Distortion.h"

FeatureFunctions::FeatureFunctions()
{
  totalSize = 0;

  sfff = new Distortion();
  totalSize += sfff->stateSize;
  sfff->startOffset = 0;

}

__device__
void FeatureFunctions::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  Distortion *castFF = static_cast<Distortion*>(sfff);
  castFF->EvaluateWhenApplied(mgr, hypo);

}
