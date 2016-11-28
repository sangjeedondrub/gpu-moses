/*
 * TargetPhrase.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <vector>
#include "Phrase.cuh"
#include "Scores.cuh"

class TargetPhrase : public Phrase
{
	TargetPhrase(const std::vector<VOCABID> &targetIds, const std::vector<SCORE> &scores);

protected:
	Scores m_scores;

};



