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

	Manager(const System &sys, const std::string &inputStr);
	virtual ~Manager();

	__host__
	void Process();

	__device__
	const Phrase &GetInput() const
	{ return *m_input; }

	__device__
  InputPath &GetInputPath(int start, int end);

  __device__
  const InputPath &GetInputPath(int start, int end) const;

  __device__
  int ComputeDistortionDistance(size_t prevEndPos,
      size_t currStartPos) const;

protected:
	Phrase *m_input;
	Stacks m_stacks;
	Vector<InputPath> m_tpsVec;

	std::string DebugTPSArr() const;

	__device__
	size_t RangeToInd(int start, int end) const;

	__host__
	void InitInputPaths();

};


__global__ void checkManager(char *str, const Manager &mgr);
