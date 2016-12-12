/*
 * StatefulFeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "FeatureFunction.h"

class StatefulFeatureFunction : public FeatureFunction
{

public:
	size_t stateSize;
	size_t startOffset;

};


