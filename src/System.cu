#include <boost/foreach.hpp>
#include "System.h"
#include "Parameter.h"

using namespace std;

System::System(const Parameter &paramsArg)
:params(paramsArg)
,featureFunctions(*this)
,weights(0)
{
  options.init(paramsArg);
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
    SetWeights(ffName, ffWeights);
  }

}

void System::SetWeights(const std::string &ffName, const std::vector<float> &ffWeights)
{
  const FeatureFunction *ff = featureFunctions.FindFeatureFunction(ffName);
  UTIL_THROW_IF2(ff == NULL, "Feature function not found:" << ffName);

  size_t startInd = ff->startInd;
  size_t numScores = ff->numScores;
  UTIL_THROW_IF2(ffWeights.size() != numScores, "Wrong number of weights for " << ff->GetName() << ":" << ffWeights.size() << "!=" << numScores);

  for (size_t i = 0; i < numScores; ++i) {
    SCORE weight = ffWeights[i];
    weights[startInd + i] = weight;
  }
}
