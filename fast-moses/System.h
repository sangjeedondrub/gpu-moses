#pragma once

#include "CUDA/Managed.h"
#include "FF/FeatureFunctions.h"

class Parameter;

class System : public Managed
{
public:
  const Parameter &params;
	FeatureFunctions featureFunctions;

	System(const Parameter &paramsArg);


protected:

};
