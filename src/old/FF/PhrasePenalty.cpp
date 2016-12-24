/*
 * PhrasePenalty.cpp
 *
 *  Created on: Oct 14, 2013
 *      Author: hieuhoang
 */

#include "PhrasePenalty.h"
#include "Scores.h"

namespace FastMoses
{

PhrasePenalty::PhrasePenalty(const std::string &line, const System &system)
  :StatelessFeatureFunction(line, system)
{
  // TODO Auto-generated constructor stub

}

PhrasePenalty::~PhrasePenalty()
{
  // TODO Auto-generated destructor stub
}

void PhrasePenalty::Evaluate(const Phrase &source
                             , const TargetPhrase &targetPhrase
                             , Scores &scores
                             , Scores &estimatedFutureScore) const
{
  scores.Add(*this, 1, m_system);
}

}
