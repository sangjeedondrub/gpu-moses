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

class Scores : public Managed
{
public:
  Scores(size_t length)
  :m_vec(true, length)
  ,m_total(0)
  {
  }

  __host__ void CreateFromString(const std::string &str);

  __device__ size_t size() const
        { return m_vec.size(); }

  __host__ size_t GetSize() const
  { return m_vec.GetSize(); }

  __device__ SCORE GetTotal() const
  { return m_total; }

  __device__ const SCORE& operator[](size_t ind) const
  { return m_vec[ind]; }

  __host__ std::string Debug() const;

protected:
  Vector<SCORE> m_vec;
  SCORE m_total;

};


