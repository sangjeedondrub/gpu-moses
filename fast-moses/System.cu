#include "System.h"
#include "Parameter.h"

using namespace std;

System::System(const Parameter &paramsArg)
:params(paramsArg)
,featureFunctions(*this)
{
  featureFunctions.Create();
}

