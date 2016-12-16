#include "UnknownWordPenalty.h"

UnknownWordPenalty::UnknownWordPenalty(const std::string &line)
:FeatureFunction(line)
{
  classId = FeatureFunction::ClassId::UnknownWordPenalty;
  numScores = 1;

}
