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
#include "CUDA/Vector.h"

class Phrase;
class PhraseTableMemory;
class TargetPhrases;

class Manager : public Managed
{
public:
	Manager(const std::string &inputStr, const PhraseTableMemory &pt);
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
	Vector<const TargetPhrases*> &GetTargetPhrases()
	{ return m_tpsVec; }

  __device__
  const TargetPhrases *GetTargetPhrases(int start, int end) const;

  __device__
  void SetTargetPhrases(int start, int end, const TargetPhrases *tps);

protected:
	Phrase *m_input;
	Stacks m_stacks;
	const PhraseTableMemory &m_pt;
	Vector<const TargetPhrases*> m_tpsVec;

	std::string DebugTPSArr() const;

};


__global__ void checkManager(char *str, const Manager &mgr);
