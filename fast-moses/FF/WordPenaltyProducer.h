#pragma once

#include <string>
#include "StatelessFeatureFunction.h"

namespace FastMoses
{

class WordPenaltyProducer : public StatelessFeatureFunction
{
public:
  WordPenaltyProducer(const std::string &line, const System &system);

  virtual void Evaluate(const Phrase &source
                        , const TargetPhrase &targetPhrase
                        , Scores &scores
                        , Scores &estimatedFutureScore) const;


};

}
