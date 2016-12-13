/*
 * StatefulFeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "FeatureFunction.h"

class Hypothesis;

class StatefulFeatureFunction : public FeatureFunction
{

public:
	size_t stateSize;
	size_t stateOffset;


  __device__
	void SetState(Hypothesis &hypo, const char *src) const;

};


