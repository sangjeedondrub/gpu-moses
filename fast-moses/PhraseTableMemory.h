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
#include "TargetPhrases.cuh"
#include "CUDA/Map.cuh"

class Node
{
public:
  Node &AddNode(const std::vector<VOCABID> &words, size_t pos = 0);

  void AddTargetPhrase(const char *str);

protected:
  typedef Map<VOCABID, Node*> Children;
  Children m_children;

  TargetPhrases tps;
};

/////////////////////////////////////////////////////////////////////////////////
class PhraseTableMemory
{
public:
	PhraseTableMemory();
	virtual ~PhraseTableMemory();

	void Load(const std::string &path);

protected:
	Node m_root;
};

