/*
 * PhrasePenalty.h
 *
 *  Created on: Oct 14, 2013
 *      Author: hieuhoang
 */
#pragma once

#include "StatelessFeatureFunction.h"

namespace FastMoses
{

class PhrasePenalty : public StatelessFeatureFunction
{
public:
  PhrasePenalty(const std::string &line, const System &system);
  virtual ~PhrasePenalty();

  void Evaluate(const Phrase &source
                , const TargetPhrase &targetPhrase
                , Scores &scores
                , Scores &estimatedFutureScore) const;

};

}

