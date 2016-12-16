/*
 * WordPenalty.h
 *
 *  Created on: 15 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "FeatureFunction.h"

class WordPenalty : public FeatureFunction
{
public:
  WordPenalty(size_t startInd, const std::string &line);
  virtual ~WordPenalty();

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const;

};

