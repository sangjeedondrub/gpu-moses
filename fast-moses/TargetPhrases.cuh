/*
 * TargetPhrases.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <thrust/device_vector.h>
#include "TargetPhrase.cuh"

class TargetPhrases
{
public:
	void Add(const TargetPhrase &tp);

protected:
  thrust::host_vector<TargetPhrase> m_vec;
  // not right. should be a device vector but causes compile error

};
