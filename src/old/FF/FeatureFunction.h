/*
 * FeatureFunction.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#pragma once

#include <vector>
#include <string>
#include <map>

namespace FastMoses {
class Scores;
class Sentence;
class TargetPhrase;
class Phrase;
class System;

class FeatureFunction
{
public:
  FeatureFunction(const std::string &line, const System &system);
  virtual ~FeatureFunction();

  virtual void Load()
  {}

  virtual void InitializeForInput(const Sentence &source)
  {}

  virtual void CleanUpAfterSentenceProcessing(const Sentence &source)
  {}

  virtual void ReadParameters();
  virtual void SetParameter(const std::string& key, const std::string& value);

  virtual void Evaluate(const Phrase &source
                        , const TargetPhrase &targetPhrase
                        , Scores &scores
                        , Scores &estimatedFutureScore) const = 0;

  size_t GetStartInd() const {
    return m_startInd;
  }
  size_t GetNumScores() const {
    return m_numScores;
  }
  const std::string &GetName() const {
    return m_name;
  }
  void Register(size_t &nextInd);

  virtual bool IsStateless() const = 0;
  virtual bool IsPhraseTable() const
  { return false; }


protected:
  std::vector<std::vector<std::string> > m_args;
  size_t m_numScores, m_startInd;
  std::string m_name;
  const System &m_system;

  void ParseLine(const std::string &line, std::string &featureName);
  void CreateName(const std::string &featureName, const System &system);

};

}

