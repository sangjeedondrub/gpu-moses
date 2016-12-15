#include "System.h"
#include "Parameter.h"

System::System(const Parameter &paramsArg)
:params(paramsArg)
,featureFunctions(*this)
{

}

