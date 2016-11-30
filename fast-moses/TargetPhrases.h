/*
 * TargetPhrases.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <thrust/device_vector.h>
#include "TargetPhrase.h"
#include "Array.h"

class TargetPhrases
{
public:

  virtual ~TargetPhrases();

  __device__ size_t size() const
  { return m_vec.size(); }

  __host__ void Add(const TargetPhrase *tp);
  __host__ std::string Debug() const;

protected:
  Array<const TargetPhrase*> m_vec;
  // not right. should be a device vector but causes compile error

};

__global__ void checkTargetPhrases(size_t &tot, const TargetPhrases &tps);

