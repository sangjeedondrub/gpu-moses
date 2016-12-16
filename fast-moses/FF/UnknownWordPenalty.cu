#include "UnknownWordPenalty.h"

UnknownWordPenalty::UnknownWordPenalty(size_t startInd, const std::string &line)
:FeatureFunction(startInd, line)
{
  classId = FeatureFunction::ClassId::UnknownWordPenalty;
  numScores = 1;

}
