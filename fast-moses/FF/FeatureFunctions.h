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
class PhraseTableMemory;

class FeatureFunctions : public Managed
{
public:
  size_t totalNumScores;
	size_t totalStateSize;

	PhraseTableMemory *pt;
  Vector<FeatureFunction*> statelessFFs;
  Vector<StatefulFeatureFunction*> statefulFFs;

	FeatureFunctions(System &system);
	~FeatureFunctions();

	__host__
  void Create();

  __host__
  void Load();

  __host__
  void EvaluateInIsolation(const Phrase &source, TargetPhrase &targetPhrase) const;

  __device__
	void EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const;

protected:
  System &m_system;

};
