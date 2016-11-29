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

  void Add(const TargetPhrase *tp);

protected:
  thrust::host_vector<const TargetPhrase*> m_vec;
  // not right. should be a device vector but causes compile error

};
