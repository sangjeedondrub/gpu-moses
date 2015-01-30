#include "WordPenaltyProducer.h"
#include "TargetPhrase.h"

namespace FastMoses
{

WordPenaltyProducer::WordPenaltyProducer(const std::string &line, const System &system)
  :StatelessFeatureFunction(line, system)
{
  ReadParameters();
}

void WordPenaltyProducer::Evaluate(const Phrase &source
                                   , const TargetPhrase &targetPhrase
                                   , Scores &scores
                                   , Scores &estimatedFutureScore) const
{
  SCORE numWords = - (SCORE) targetPhrase.GetSize();
  scores.Add(*this, numWords, m_system);
}

}

