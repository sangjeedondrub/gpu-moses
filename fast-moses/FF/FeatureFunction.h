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

  virtual ~FeatureFunction()
  {}

  virtual void Load(System &system)
  {}

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
  };

protected:
  std::vector<std::vector<std::string> > m_args;
  std::string m_name;

  void ParseLine(const std::string &line);

};
