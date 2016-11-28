/*
 * Phrase.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */
#pragma once
#include <thrust/device_vector.h>
#include <string>
#include "TypeDef.h"

class Phrase
{
public:
	static Phrase *CreateFromString(const std::string &str);

	Phrase(const std::vector<VOCABID> &ids);

protected:
  thrust::device_vector<VOCABID> m_vec;
};

