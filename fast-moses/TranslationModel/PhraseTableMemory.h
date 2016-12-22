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
#include "../FF/FeatureFunction.h"

class Node : public Managed
{
public:
  typedef Map<VOCABID, Node*> Children;

  Node();

  virtual ~Node();

  __host__
  const Children &GetChildren() const
  { return m_children; }

  __host__
  Node &AddNode(const std::vector<VOCABID> &words, size_t pos = 0);

  __device__
  const TargetPhrases *Lookup(const Phrase &phrase, size_t start, size_t end, size_t pos) const;

  __host__
  TargetPhrases &GetTargetPhrases();

protected:
  Children m_children;

  TargetPhrases *m_tps;

};

/////////////////////////////////////////////////////////////////////////////////
class PhraseTableMemory : public FeatureFunction
{
public:
	PhraseTableMemory(size_t startInd, const std::string &line);
	virtual ~PhraseTableMemory();

	virtual void Load(System &system);

	__device__
	const TargetPhrases *Lookup(const Phrase &phrase, size_t start, size_t end) const;

  __host__
  virtual void EvaluateInIsolation(
      const System &system,
      const Phrase &source,
      const TargetPhrase &targetPhrase,
      Scores &scores,
      SCORE &estimatedScore) const
  {}

protected:
	Node m_root;
	std::string m_path;

  virtual void SetParameter(const std::string& key, const std::string& value);

};

