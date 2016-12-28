#pragma once

#include "CUDA/Managed.h"
#include "FF/FeatureFunctions.h"
#include "parameters/AllOptions.h"

class Parameter;

class System : public Managed
{
public:
  const Parameter &params;
	FeatureFunctions featureFunctions;
	Vector<SCORE> weights;
	AllOptions options;

	System(const Parameter &paramsArg);


protected:
	void LoadWeights();
	void SetWeights(const std::string &ffName, const std::vector<float> &ffWeights);

};
