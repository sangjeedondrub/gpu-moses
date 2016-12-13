#include "StatefulFeatureFunction.h"
#include "../Hypothesis.h"

  __device__
void StatefulFeatureFunction::SetState(Hypothesis &hypo, const char *src) const
{
    memcpy(&hypo.stateData[stateOffset], src, stateSize);
}
