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
#include "WordPenalty.h"
#include "../Parameter.h"
#include "../System.h"

using namespace std;


FeatureFunctions::FeatureFunctions(System &system)
:m_system(system)
,statelessFFs(0)
,statefulFFs(0)
{

}

__host__
void FeatureFunctions::Create()
{
  const Parameter &params = m_system.params;

  const PARAM_VEC *ffParams = params.GetParam("feature");
  UTIL_THROW_IF2(ffParams == NULL, "Must have [feature] section");

  totalStateSize = 0;

  BOOST_FOREACH(const std::string &line, *ffParams){
    cerr << "line=" << line << endl;
    vector<string> toks = Tokenize(line);
    assert(toks.size());

    FeatureFunction *ff = NULL;
    if (toks[0] == "Distortion") {
      ff = new Distortion();
    }
    else if (toks[0] == "WordPenalty") {
      ff = new WordPenalty();
    }


    // put into correct vector
    if (ff) {
      StatefulFeatureFunction *sfff = dynamic_cast<StatefulFeatureFunction*>(ff);
      if (sfff) {
        sfff->stateOffset = totalStateSize;
        totalStateSize += sfff->stateSize;

        statefulFFs.PushBack(sfff);
      }
      else {
        statelessFFs.PushBack(ff);
      }

    }

  }

  cerr << "statelessFFs=" << statelessFFs.size() << endl;
  cerr << "statefulFFs=" << statefulFFs.size() << endl;

}

__device__
void FeatureFunctions::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  for (size_t i = 0; i < statefulFFs.size(); ++i) {
    const StatefulFeatureFunction *sfff = statefulFFs[i];

    switch (sfff->classId) {
    case FeatureFunction::ClassId::Distortion:
      const Distortion *castFF = static_cast<const Distortion*>(sfff);
      castFF->EvaluateWhenApplied(mgr, hypo);
      break;

    }
  }

}


