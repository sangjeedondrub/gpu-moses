/*
 * Node.h
 *
 *  Created on: 22 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "CUDA/Managed.h"
#include "CUDA/Map.h"
#include "CUDA/Array.h"
#include "Phrase.h"

template<typename T>
class Node : public Managed
{
public:
  typedef Map<VOCABID, Node*> Children;
  T value;

  Node(const T &defVal)
  :m_children()
  ,value(defVal)
  {}

  virtual ~Node()
  {
    const typename Children::Vec &vec = m_children.GetVec();
    for (size_t i = 0; i < vec.size(); ++i) {
      const typename Children::Pair &pair = vec[i];
      const Node *node = pair.second;
      delete node;
    }
  }

  __host__
  const Children &GetChildren() const
  { return m_children; }

  __host__
  Node &AddOrCreateNode(const std::vector<VOCABID> &words, const T &defVal, size_t pos = 0)
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
  const Node *Lookup(const Phrase &phrase, size_t start, size_t end, size_t pos) const
  {
    if (pos > end) {
      return this;
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

  __device__
  const T &Lookup(const Array<VOCABID> &phrase, size_t pos, const T &emptyVal) const
  {
    if (pos >= phrase.size()) {
      return value;
    }

    VOCABID vocabId = phrase[pos];
    thrust::pair<bool, size_t> upper = m_children.upperBound(vocabId);
    //return (const TargetPhrases *) m_children.size();

    if (upper.first) {
      const Node *node = m_children.GetValue(upper.second);
      assert(node);
      return node->Lookup(phrase, pos + 1, emptyVal);
    }
    else {
      //return (const TargetPhrases *) 0x987;
      return emptyVal;
    }
  }

protected:
  Children m_children;


};





