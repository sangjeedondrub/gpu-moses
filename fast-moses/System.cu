#include <boost/foreach.hpp>
#include "System.h"
#include "Parameter.h"

using namespace std;

System::System(const Parameter &paramsArg)
:params(paramsArg)
,featureFunctions(*this)
,weights(0)
{
  featureFunctions.Create();
  LoadWeights();

  featureFunctions.Load();
}

void System::LoadWeights()
{
  weights.Resize(featureFunctions.totalNumScores);

  typedef std::map<std::string, std::vector<float> > WeightMap;
  const WeightMap &allWeights = params.GetAllWeights();
  BOOST_FOREACH(const WeightMap::value_type &valPair, allWeights) {
    const string &ffName = valPair.first;
    const std::vector<float> &ffWeights = valPair.second;
    /*
    cerr << ffName << "=";
    for (size_t i = 0; i < ffWeights.size(); ++i) {
      cerr << ffWeights[i] << " ";
    }
    cerr << endl;
    */
    //weights.SetWeights(featureFunctions, ffName, ffWeights);
  }

}
