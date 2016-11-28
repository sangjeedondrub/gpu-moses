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
	void Add(const TargetPhrase &tp);

protected:
  thrust::device_vector<TargetPhrase> m_vec;

};
