/*
 * LanguageModel.h
 *
 *  Created on: 16 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "../FF/StatefulFeatureFunction.h"

class LanguageModel : public StatefulFeatureFunction
{
public:
  LanguageModel(size_t startInd, const std::string &line);

  virtual ~LanguageModel();

  virtual void Load(System &system);

  virtual void SetParameter(const std::string& key, const std::string& value);

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const;

protected:
  std::string m_path;
  FactorType m_factorType;
  size_t m_order;

  SCORE m_oov;

};


