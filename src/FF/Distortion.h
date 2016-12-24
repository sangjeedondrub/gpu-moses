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
	Distortion(size_t startInd, const std::string &line);

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const
  {}

  __device__
	void EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const;


protected:

  __device__
  int ComputeDistortionDistance(const Range& prev,
      const Range& current) const;

};


