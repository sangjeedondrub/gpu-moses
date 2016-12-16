#pragma once
#include "FeatureFunction.h"

class UnknownWordPenalty : public FeatureFunction
{
public:
  UnknownWordPenalty(const std::string &line);

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const
  {}

};


