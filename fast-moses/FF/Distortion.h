/*
 * Distortion.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once

#include "StatefulFeatureFunction.h"

class Range;

class Distortion : public StatefulFeatureFunction
{
public:
	Distortion();

  __device__
	void EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const;


protected:

  __device__
  int ComputeDistortionDistance(const Range& prev,
      const Range& current) const;

};


