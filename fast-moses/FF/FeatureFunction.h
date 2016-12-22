/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include <vector>
#include <string>
#include "../CUDA/Managed.h"
#include "../TypeDef.h"

class Manager;
class System;
class Scores;
class Phrase;
class TargetPhrase;


class FeatureFunction : public Managed
{
public:
  size_t classId;
  size_t startInd;
  size_t numScores;

  FeatureFunction(size_t startInd, const std::string &line);

  virtual ~FeatureFunction()
  {}

  virtual void Load(System &system)
  {}

  const std::string &GetName() const
  {
    return m_name;
  }

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const = 0;


  enum ClassId
  {
    Distortion = 123,
    WordPenalty = 567,
    PhraseDictionaryMemory = 6,
    UnknownWordPenalty = 543,
    LanguageModel = 2
  };

protected:
  std::vector<std::vector<std::string> > m_args;
  std::string m_name;
  bool m_tuneable;

  virtual void SetParameter(const std::string& key, const std::string& value);
  virtual void ReadParameters();
  void ParseLine(const std::string &line);

};
