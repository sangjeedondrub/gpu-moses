#include "WordPenalty.h"
#include "../Scores.h"
#include "../TargetPhrase.h"

WordPenalty::WordPenalty(size_t startInd, const std::string &line)
:FeatureFunction(startInd, line)
{
  classId = FeatureFunction::ClassId::WordPenalty;

  ReadParameters();
}

WordPenalty::~WordPenalty()
{

}

__host__
void WordPenalty::EvaluateInIsolation(
    const System &system,
    const Phrase &source,
    const TargetPhrase &targetPhrase,
    Scores &scores,
    SCORE &estimatedScore) const
{
  size_t size = targetPhrase.GetSize();
  scores.PlusEqual(system, *this, - (SCORE) size);
}
