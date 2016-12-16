/*
 * LanguageModel.h
 *
 *  Created on: 16 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "../FF/StatefulFeatureFunction.h"

class LanguageModel : public StatefulFeatureFunction
{
public:
  LanguageModel(size_t startInd, const std::string &line);

  virtual ~LanguageModel();

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const;

};


