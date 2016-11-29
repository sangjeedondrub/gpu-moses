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
#include "Array.h"
#include "Managed.h"

class Phrase : public Managed
{
public:
	static Phrase *CreateFromString(const std::string &str);

	Phrase(const std::vector<VOCABID> &ids);

	size_t GetSize() const
	{ return m_vec.GetSize(); }

	std::string Debug() const;
protected:
	Array<VOCABID> m_vec;
};

