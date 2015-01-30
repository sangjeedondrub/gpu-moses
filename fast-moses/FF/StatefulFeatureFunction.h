/*
 * FeatureFunction.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#pragma once

#include "FeatureFunction.h"

class FFState;

namespace FastMoses
{
class Hypothesis;
class Scores;

class StatefulFeatureFunction : public FeatureFunction
{
public:
  StatefulFeatureFunction(const std::string &line, const System &system);
  virtual ~StatefulFeatureFunction();

  virtual size_t Evaluate(
    const Hypothesis& hypo,
    size_t prevState,
    Scores &scores) const = 0;
  virtual size_t EmptyHypo(
    const Sentence &input,
    Hypothesis& hypo) const {
    return 0;
  }

  bool IsStateless() const
  { return false; }

  virtual bool UseStateClass() const = 0;

protected:

};

}
