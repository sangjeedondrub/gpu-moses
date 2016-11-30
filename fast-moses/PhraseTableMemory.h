/*
 * PhraseTableMemory.h
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */
#pragma once
#include <string>
#include <vector>
#include "TypeDef.h"
#include "TargetPhrases.h"
#include "Managed.h"
#include "CUDA/Map.h"

class Node : public Managed
{
public:
  typedef Map<VOCABID, Node*> Children;

  Node();

  const Children &GetChildren() const
  { return m_children; }

  Node &AddNode(const std::vector<VOCABID> &words, size_t pos = 0);

  virtual ~Node();

  TargetPhrases &GetTargetPhrases();

protected:
  Children m_children;

  TargetPhrases *tps;
};

/////////////////////////////////////////////////////////////////////////////////
class PhraseTableMemory
{
public:
	PhraseTableMemory();
	virtual ~PhraseTableMemory();

	void Load(const std::string &path);

protected:
	Node *m_root;
};

