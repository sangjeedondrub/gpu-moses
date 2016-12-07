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
#include "CUDA/Managed.h"
#include "CUDA/Map.h"
#include "Array.h"

class Node : public Managed
{
public:
  typedef Map2<VOCABID, Node*> Children;

  Node();

  virtual ~Node();

  __host__
  const Children &GetChildren() const
  { return m_children; }

  __host__
  Node &AddNode(const std::vector<VOCABID> &words, size_t pos = 0);

  __device__
  void Lookup(const Phrase &phrase, size_t pos = 0) const;

  TargetPhrases &GetTargetPhrases();

protected:
  Children m_children;

  TargetPhrases *tps;

};

/////////////////////////////////////////////////////////////////////////////////
class PhraseTableMemory : public Managed
{
public:
	PhraseTableMemory();
	virtual ~PhraseTableMemory();

	void Load(const std::string &path);

	__device__
	void Lookup(const Phrase &phrase, size_t start, size_t end) const;

protected:
	Node m_root;
};

