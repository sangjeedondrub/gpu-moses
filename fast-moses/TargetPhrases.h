/*
 * TargetPhrases.h
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#pragma once

#include <vector>
#include "TypeDef.h"

namespace FastMoses
{
class TargetPhrase;
class PhraseTable;

class TargetPhrases
{
  typedef std::vector<const TargetPhrase*> Coll;

public:
  typedef Coll::iterator iterator;
  typedef Coll::const_iterator const_iterator;

  const_iterator begin() const {
    return m_coll.begin();
  }
  const_iterator end() const {
    return m_coll.end();
  }

  TargetPhrases();
  virtual ~TargetPhrases();

  void Add(const TargetPhrase *tp) {
    m_coll.push_back(tp);
  }

  size_t GetSize() const {
    return m_coll.size();
  }

  void CalcFutureScore();
  SCORE GetFutureScore() const {
    return m_futureScore;
  }

  void CreateMemory(const PhraseTable &pt);
  void WriteMemory() const;

  size_t GetMemSize() const
  { return m_memSize; }
  void *GetMem() const
  { return m_mem; }

protected:
  Coll m_coll;
  SCORE m_futureScore;

  size_t m_memSize;
  void *m_mem;
};

}

