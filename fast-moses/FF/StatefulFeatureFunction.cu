#include "StatefulFeatureFunction.h"
#include "../Hypothesis.h"

StatefulFeatureFunction::StatefulFeatureFunction(const std::string &line)
:FeatureFunction(line)
{

}

  __device__
void StatefulFeatureFunction::SetState(Hypothesis &hypo, const char *src) const
{
    memcpy(&hypo.stateData[stateOffset], src, stateSize);
}
