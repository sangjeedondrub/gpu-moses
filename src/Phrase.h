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
#include "CUDA/Vector.h"
#include "CUDA/Managed.h"

class Phrase : public Managed
{
public:
	static Phrase *CreateFromString(const std::string &str);

	__host__
	Phrase(const std::vector<VOCABID> &ids);

	__host__
  Phrase(size_t size);

  __device__ const VOCABID& operator[](size_t ind) const
	{
	  return m_vec[ind];
	}

	__device__ size_t size() const
        { return m_vec.size(); }

	__host__ size_t GetSize() const
	{ return m_vec.size(); }

	__host__ std::string Debug() const;
protected:
	Vector<VOCABID> m_vec;
};

__global__ void checkPhrase(char *str, const Phrase &phrase);

