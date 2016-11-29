/*
 * Scores.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <thrust/device_vector.h>
#include "TypeDef.h"
#include "Array.h"

class Scores
{
public:
	Scores(size_t length)
	:m_vec(length)
	{}

	void CreateFromString(const std::string &str);


protected:
  Array<SCORE> m_vec;

};


