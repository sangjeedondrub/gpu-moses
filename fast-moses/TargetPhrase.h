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

class TargetPhrase : public Phrase
{
public:
	static TargetPhrase *CreateFromString(const std::string &str);

	__host__ TargetPhrase(const std::vector<VOCABID> &targetIds);

	__host__ Scores &GetScores()
	{ return m_scores; }

  __host__ std::string Debug() const;

protected:
	Scores m_scores;

};



