/*
 * Manager.h
 *
 *  Created on: 28 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <string>
#include "Stacks.h"
#include "CUDA/Managed.h"

class Phrase;
class PhraseTableMemory;

class Manager : public Managed
{
public:
	Manager(const std::string &inputStr, const PhraseTableMemory &pt);
	virtual ~Manager();

	__host__ void Process();

	__device__ const Phrase &GetInput() const
	{ return *m_input; }

protected:
	Phrase *m_input;
	Stacks m_stacks;
	const PhraseTableMemory &m_pt;
};


__global__ void checkManager(char *str, const Manager &mgr);
