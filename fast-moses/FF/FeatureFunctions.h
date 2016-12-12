/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "StatefulFeatureFunction.h"

class FeatureFunctions
{
public:
	static FeatureFunctions s_instance;

	size_t totalSize;
	StatefulFeatureFunction *sfff;

	FeatureFunctions();

protected:

};
