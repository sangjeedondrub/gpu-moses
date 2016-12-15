/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */
#include <boost/foreach.hpp>
#include "FeatureFunctions.h"
#include "Distortion.h"
#include "../Parameter.h"
#include "../System.h"

FeatureFunctions::FeatureFunctions(System &system)
:m_system(system)
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

  }

}

__device__
void FeatureFunctions::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  Distortion *castFF = static_cast<Distortion*>(sfff);
  castFF->EvaluateWhenApplied(mgr, hypo);

}


