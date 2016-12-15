/*
 * ScoresUnmanaged.h
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "TypeDef.h"
#include "Scores.h"

class FeatureFunction;
class System;

class ScoresUnmanaged
{
public:
  __device__
  ScoresUnmanaged(const System &sys, size_t size, const SCORE &val = 0);

  __device__
  ~ScoresUnmanaged();

  __device__
  void PlusEqual(const System &sys, const ScoresUnmanaged &other);

  __device__
  void PlusEqual(const System &sys, const Scores &other);

  __device__
  void PlusEqual(const System &sys, const FeatureFunction &ff, SCORE score);

  __device__ SCORE GetTotal() const
  { return m_total; }

protected:
  SCORE *m_scores;
  SCORE m_total;
};



