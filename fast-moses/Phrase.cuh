/*
 * Phrase.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */
#pragma once
#include <thrust/device_vector.h>
#include "TypeDef.h"

class Phrase
{
public:
	Phrase(size_t length)
	:m_vec(length)
	{}

protected:
  thrust::device_vector<VOCABID> m_vec;
};

