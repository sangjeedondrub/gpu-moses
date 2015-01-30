/*
 * System.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */
#pragma once

#include <map>
#include <string>
#include <vector>
#include <fstream>
#include "Weights.h"
#include "Timer.h"

namespace FastMoses
{
class FeatureFunction;
class StatelessFeatureFunction;
class StatefulFeatureFunction;
class PhraseTable;
class Sentence;
class Phrase;
class TargetPhrase;
class Scores;
  
class System
{
public:
  
  size_t stackSize;
  int maxDistortion;
  Weights weights;
  
  std::vector<FeatureFunction*> m_ffs;
  std::vector<StatelessFeatureFunction*> m_slffs;
  std::vector<StatefulFeatureFunction*> m_sfffs;
  std::vector<PhraseTable*> m_pts;
  
  mutable Moses::Timer timer;
  mutable std::map<std::string, size_t> m_nameInd;

  System();
  virtual ~System();
  void Init(int argc, char** argv);
  void Init(const char *iniPath);

  std::istream &GetInputStream() const {
    return *m_inputStrme;
  }

  FeatureFunction &FindFeatureFunction(const std::string& name);
  void Initialize(const Sentence &source);
  void CleanUpAfterSentenceProcessing(const Sentence &source);

  size_t GetTotalNumScores() const
  { return m_nextInd; }

  const std::vector<std::string> &GetDescription() const
  { return m_descr; }

  std::string Debug() const;
protected:
  std::string m_iniPath, m_inputPath;
  mutable std::istream *m_inputStrme;
  size_t m_nextInd;

  typedef std::vector<std::string> ParamList;
  typedef std::map<std::string, ParamList> Params;
  Params m_params;

  std::vector<std::string> m_descr;
  
  void InitParams();
  void InitFF();
  void InitWeight();
  void Load();

  bool ParamExist(const std::string &key) const;
};

}
