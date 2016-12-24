#include "StatefulFeatureFunction.h"
#include "../Hypothesis.h"

StatefulFeatureFunction::StatefulFeatureFunction(size_t startInd, const std::string &line)
:FeatureFunction(startInd, line)
{

}

  __device__
void StatefulFeatureFunction::SetState(Hypothesis &hypo, const char *src) const
{
    memcpy(&hypo.stateData[stateOffset], src, stateSize);
}
