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
  TargetPhrases *tps;

  Node::Node(TargetPhrases *defVal)
  :m_children()
  ,tps(defVal)
  {}

  virtual ~Node()
  {
    const Children::Vec &vec = m_children.GetVec();
    for (size_t i = 0; i < vec.size(); ++i) {
      const Children::Pair &pair = vec[i];
      const Node *node = pair.second;
      delete node;
    }
  }

  __host__
  const Children &GetChildren() const
  { return m_children; }

  __host__
  Node &AddOrCreateNode(const std::vector<VOCABID> &words, TargetPhrases *defVal, size_t pos = 0)
  {
    //cerr << "pos=" << pos << endl;
    if (pos >= words.size()) {
      //cerr << "found=" << pos << endl;
      return *this;
    }

    VOCABID vocabId = words[pos];
    Node *node;

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
      node = new Node(defVal);
      //cudaMallocManaged(&node, sizeof(Node));
      m_children.Insert(vocabId, node);
    }

    node = &node->AddOrCreateNode(words, defVal, pos + 1);
    return *node;
  }

  __device__
  const TargetPhrases *Lookup(const Phrase &phrase, size_t start, size_t end, size_t pos) const
  {
    if (pos > end) {
      return tps;
    }

    VOCABID vocabId = phrase[pos];
    thrust::pair<bool, size_t> upper = m_children.upperBound(vocabId);
    //return (const TargetPhrases *) m_children.size();

    if (upper.first) {
      const Node *node = m_children.GetValue(upper.second);
      assert(node);
      return node->Lookup(phrase, start, end, pos + 1);
    }
    else {
      //return (const TargetPhrases *) 0x987;
      return NULL;
    }
  }

protected:
  Children m_children;


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

