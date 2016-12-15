#include "WordPenalty.h"
#include "../Scores.h"
#include "../TargetPhrase.h"

WordPenalty::WordPenalty()
{
  classId = FeatureFunction::ClassId::WordPenalty;
  numScores = 1;
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
  scores.PlusEqual(system, *this, (SCORE) size);
}
