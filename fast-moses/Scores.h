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
#include "Managed.h"

class Scores : public Managed
{
public:
	Scores(size_t length)
	:m_vec(length)
	{}

	__host__ void CreateFromString(const std::string &str);

  __host__ std::string Debug() const;


protected:
  Array<SCORE> m_vec;

};


