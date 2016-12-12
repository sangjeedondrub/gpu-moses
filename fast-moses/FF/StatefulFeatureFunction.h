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

	virtual size_t GetStateSize() = 0;

};


