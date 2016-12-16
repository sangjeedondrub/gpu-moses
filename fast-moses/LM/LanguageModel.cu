#include "LanguageModel.h"

LanguageModel::LanguageModel(size_t startInd, const std::string &line)
:StatefulFeatureFunction(startInd, line)
{

}

LanguageModel::~LanguageModel()
{

}

void LanguageModel::EvaluateInIsolation(
    const System &system,
    const Phrase &source,
    const TargetPhrase &targetPhrase,
    Scores &scores,
    SCORE &estimatedScore) const
{

}

