/*
 * Manager.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#pragma once

#include "Sentence.h"
#include "TargetPhrase.h"
#include "WordsRange.h"

namespace FastMoses
{
class InputPath;
class System;
  
class Manager
{
public:
  System &m_system;

  Manager(Sentence &sentence, System &system);
  virtual ~Manager();

  std::string Debug() const;

protected:
  Sentence &m_sentence;
  std::vector<InputPath*> m_inputPathQueue;
  
  TargetPhrase m_emptyPhrase;
  WordsRange m_emptyRange;

  void CreateInputPaths();
  void CreateInputPaths(const InputPath &prevPath, size_t pos);

  void Lookup();
  void Search();
  
  void WriteMemoryToDevice();
};

}
