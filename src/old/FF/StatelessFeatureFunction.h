/*
 * FeatureFunction.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#pragma once

#include "FeatureFunction.h"

namespace FastMoses
{

class StatelessFeatureFunction : public FeatureFunction
{
public:
  StatelessFeatureFunction(const std::string &line, const System &system);
  virtual ~StatelessFeatureFunction();

  bool IsStateless() const
  { return true; }


};

}

