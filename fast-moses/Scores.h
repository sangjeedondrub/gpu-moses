/*
 * Scores.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <thrust/device_vector.h>
#include "TypeDef.h"
#include "CUDA/Vector.h"
#include "CUDA/Managed.h"

class System;
class FeatureFunction;

class Scores : public Managed
{
public:
  Scores(size_t length)
  :m_vec(length)
  ,m_total(0)
  {
  }

  __host__
  void CreateFromString(const System &system, const FeatureFunction &ff, const std::string &str, bool transformScores);

  __device__
  size_t size() const
        { return m_vec.size(); }


  __device__
  SCORE GetTotal() const
  { return m_total; }

  __device__
  const SCORE& operator[](size_t ind) const
  { return m_vec[ind]; }

  __host__
  void PlusEqual(const System &sys, const FeatureFunction &ff, const std::vector<SCORE> &scores);

  __host__
  std::string Debug() const;

protected:
  Vector<SCORE> m_vec;
  SCORE m_total;

};


