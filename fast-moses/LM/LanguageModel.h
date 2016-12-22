/*
 * LanguageModel.h
 *
 *  Created on: 16 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "../FF/StatefulFeatureFunction.h"
#include "../Node.h"

struct LMScores
{
  LMScores(bool foundA, SCORE probA, SCORE backoffA)
  :found(foundA)
  ,prob(probA)
  ,backoff(backoffA)
  {
  }

  bool found;
  SCORE prob, backoff;
};

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

  __device__
  void EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const;

protected:
  std::string m_path;
  FactorType m_factorType;
  size_t m_order;

  SCORE m_oov;

  LMScores m_unkScores;
  Node<LMScores> m_root;
};


