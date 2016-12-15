/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */
#include <vector>
#include <boost/foreach.hpp>
#include "FeatureFunctions.h"
#include "Distortion.h"
#include "../Parameter.h"
#include "../System.h"

using namespace std;


FeatureFunctions::FeatureFunctions(System &system)
:m_system(system)
,statefulFeatureFunctions(0)
{
  totalSize = 0;

  sfff = new Distortion();
  totalSize += sfff->stateSize;
  sfff->stateOffset = 0;

}

__host__
void FeatureFunctions::Create()
{
  const Parameter &params = m_system.params;

  const PARAM_VEC *ffParams = params.GetParam("feature");
  UTIL_THROW_IF2(ffParams == NULL, "Must have [feature] section");

  BOOST_FOREACH(const std::string &line, *ffParams){
    cerr << "line=" << line << endl;
    vector<string> toks = Tokenize(line);
    assert(toks.size());

    FeatureFunction *ff = NULL;
    if (toks[0] == "Distortion") {
      ff = new Distortion();
    }

    if (ff) {
      StatefulFeatureFunction *sfff = dynamic_cast<StatefulFeatureFunction*>(ff);
      if (sfff) {
        statefulFeatureFunctions.PushBack(sfff);
      }
    }

  }

  cerr << "statefulFeatureFunctions=" << statefulFeatureFunctions.size() << endl;

}

__device__
void FeatureFunctions::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  Distortion *castFF = static_cast<Distortion*>(sfff);
  castFF->EvaluateWhenApplied(mgr, hypo);

}


