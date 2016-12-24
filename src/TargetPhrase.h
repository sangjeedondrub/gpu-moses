/*
 * TargetPhrase.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <vector>
#include <string>
#include "Phrase.h"
#include "Scores.h"

class System;

class TargetPhrase : public Phrase
{
public:
	static TargetPhrase *CreateFromString(const System &sys, const std::string &str);

  __host__
  TargetPhrase(const System &sys, size_t size);

	__host__
	TargetPhrase(const System &sys, const std::vector<VOCABID> &targetIds);

	__host__
	Scores &GetScores()
	{ return m_scores; }

  __device__
  const Scores &GetScores() const
  { return m_scores; }

  __host__
  std::string Debug() const;

protected:
	Scores m_scores;

};

__global__ void checkTargetPhrase(char *str, const TargetPhrase &phrase);



