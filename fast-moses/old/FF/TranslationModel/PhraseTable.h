/*
 * PhraseTable.h
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#pragma once

#include "FF/StatelessFeatureFunction.h"

namespace FastMoses
{
class InputPath;

class PhraseTable :public StatelessFeatureFunction
{
public:
  PhraseTable(const std::string line, const System &system);
  virtual ~PhraseTable();

  void SetPtId(size_t ptId) {
    m_ptId = ptId;
  }
  
  virtual void Lookup(const std::vector<InputPath*> &inputPathQueue) = 0;

  virtual bool IsPhraseTable() const
  { return true; }

protected:

  size_t m_ptId;

};

}

