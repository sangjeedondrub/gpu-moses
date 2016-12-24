/*
 * Node.h
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#pragma once

#include <map>
#include "Word.h"
#include "TargetPhrase.h"
#include "TargetPhrases.h"

class Phrase;

namespace FastMoses
{
class PhraseTable;

class Node
{
public:
  typedef std::map<Word, Node*> Children;

  Node();
  virtual ~Node();

  Node &GetOrCreate(const Phrase &source, size_t pos);
  const Node *Get(const Word &word) const;

  void AddTarget(TargetPhrase *target);
  const TargetPhrases &GetTargetPhrases() const {
    return m_tpColl;
  }

  void CreateMemory(const PhraseTable &pt);

protected:
  Children m_children;
  TargetPhrases m_tpColl;
};

}
