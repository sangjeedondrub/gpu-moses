/*
 * TargetPhrase.cuh
 *
 *  Created on: 27 Nov 2016
 *      Author: hieu
 */

#pragma once
#include "Phrase.cuh"
#include "Scores.cuh"

class TargetPhrase : public Phrase
{
	TargetPhrase(size_t length)
	:Phrase(length)
	,m_scores(4)
	{}

protected:
	Scores m_scores;

};



