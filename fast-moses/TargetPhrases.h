/*
 * TargetPhrases.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <thrust/device_vector.h>
#include "TargetPhrase.h"

class TargetPhrases
{
public:

  virtual ~TargetPhrases();

  __host__ void Add(const TargetPhrase *tp);
  __host__ std::string Debug() const;

protected:
  thrust::host_vector<const TargetPhrase*> m_vec;
  // not right. should be a device vector but causes compile error

};
