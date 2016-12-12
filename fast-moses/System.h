#pragma once

#include "CUDA/Managed.h"
#include "FF/FeatureFunctions.h"

class System : public Managed
{
public:
	FeatureFunctions ffs;

};
