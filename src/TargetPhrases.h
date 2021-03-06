/*
 * TargetPhrases.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include "TargetPhrase.h"
#include "CUDA/Vector.h"
#include "CUDA/Managed.h"

class TargetPhrases : public Managed
{
public:
  TargetPhrases();

  virtual ~TargetPhrases();

  __device__ size_t size() const
  { return m_vec.size(); }

  __host__ size_t GetSize() const
  { return m_vec.size(); }

  __host__ void Add(const TargetPhrase *tp);
  __host__ std::string Debug() const;

  __host__ __device__
  const TargetPhrase* operator[](size_t ind) const
  { return m_vec[ind]; }

protected:
  Vector<const TargetPhrase*> m_vec;
  // not right. should be a device vector but causes compile error

};

__global__ void checkTargetPhrases(char *str, const TargetPhrases &tps);

