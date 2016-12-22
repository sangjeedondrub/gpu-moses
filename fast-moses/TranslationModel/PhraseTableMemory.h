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

template<typename Key, typename Value>
class Trie : public Managed
{
public:
  typedef Map<Key, Trie*> Children;
  Value value;

  Trie()
  :m_children()
  {}

  virtual ~Trie() {}

  __host__
  const Children &GetChildren() const
  { return m_children; }

  __host__
  Trie &AddOrCreateNode(const std::vector<Key> &words, size_t pos)
  {
    //cerr << "pos=" << pos << endl;
    if (pos >= words.size()) {
      //cerr << "found=" << pos << endl;
      return *this;
    }

    Key vocabId = words[pos];
    Trie *node;

    /*
    cerr << "vocabId=" << vocabId << endl;
    size_t numChildren = m_children.GetSize();
    cerr << "node=" << this << " " << numChildren << ":";
    for (size_t i = 0; i < numChildren; ++i) {
      const Children::Pair &pair = m_children.GetVec()[i];

      cerr << pair.first << " ";
    }
    cerr << endl;
    */

    thrust::pair<bool, size_t> upper = m_children.UpperBound(vocabId);
    //cerr << "upper=" << upper.first << " " << upper.second << endl;
    if (upper.first) {
      size_t ind = upper.second;
      node = m_children.GetValue(ind);
    }
    else {
      node = new Trie();
      //cudaMallocManaged(&node, sizeof(Node));
      m_children.Insert(vocabId, node);
    }

    node = &node->AddOrCreateNode(words, pos + 1);
    return *node;
  }


protected:
  Children m_children;

};

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
  Node &AddOrCreateNode(const std::vector<VOCABID> &words, size_t pos = 0);

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

