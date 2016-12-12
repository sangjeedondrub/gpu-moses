/*
 * Distortion.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once

#include "StatefulFeatureFunction.h"

class Distortion : public StatefulFeatureFunction
{
public:
	Distortion();

  __device__
	void EvaluateWhenApplied(Hypothesis &hypo);
};


