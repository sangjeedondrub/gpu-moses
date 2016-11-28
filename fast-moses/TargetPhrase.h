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

	TargetPhrase(const std::vector<VOCABID> &targetIds);

	Scores &GetScores()
	{ return m_scores; }

protected:
	Scores m_scores;

};



