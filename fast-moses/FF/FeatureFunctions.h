/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "StatefulFeatureFunction.h"
#include "../CUDA/Managed.h"

class FeatureFunctions : public Managed
{
public:
	size_t totalSize;
	StatefulFeatureFunction *sfff;

	FeatureFunctions();

protected:

};
