/*
 * Manager.h
 *
 *  Created on: 28 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <string>
#include "Stacks.h"
#include "InputPath.h"
#include "TargetPhrase.h"
#include "CUDA/Managed.h"
#include "CUDA/Vector.h"

class Phrase;
class PhraseTableMemory;
class TargetPhrases;
class System;

class Manager : public Managed
{
public:
	const System &system;
  InputPath initPath;
  TargetPhrase initPhrase;

	Manager(const System &sys, const std::string &inputStr, const PhraseTableMemory &pt);
	virtual ~Manager();

	__host__
	void Process();

	__device__
	const Phrase &GetInput() const
	{ return *m_input; }

	__device__
	const PhraseTableMemory &GetPhraseTable() const
  { return m_pt; }

	__device__
  InputPath &GetInputPath(int start, int end);

  __device__
  const InputPath &GetInputPath(int start, int end) const;


protected:
	Phrase *m_input;
	Stacks m_stacks;
	const PhraseTableMemory &m_pt;
	Vector<InputPath> m_tpsVec;

	std::string DebugTPSArr() const;

	__device__
	size_t RangeToInd(int start, int end) const;

	__host__
	void InitInputPaths();

};


__global__ void checkManager(char *str, const Manager &mgr);
