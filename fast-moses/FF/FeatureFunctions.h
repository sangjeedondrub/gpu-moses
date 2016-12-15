/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "StatefulFeatureFunction.h"
#include "../CUDA/Managed.h"
#include "../CUDA/Vector.h"

class Hypothesis;
class Manager;
class System;
class StatefulFeatureFunction;

class FeatureFunctions : public Managed
{
public:
	size_t totalStateSize;

  Vector<const FeatureFunction*> statelessFFs;
  Vector<const StatefulFeatureFunction*> statefulFFs;

	FeatureFunctions(System &system);

	__host__
  void Create();

	__device__
	void EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const;

protected:
  System &m_system;

};
