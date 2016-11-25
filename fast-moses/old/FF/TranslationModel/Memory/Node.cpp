/*
 * Node.cpp
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#include "Node.h"
#include "Phrase.h"

namespace FastMoses
{

Node::Node()
{
  // TODO Auto-generated constructor stub

}

Node::~Node()
{
  // TODO Auto-generated destructor stub
}

Node &Node::GetOrCreate(const Phrase &source, size_t pos)
{
  if (pos == source.GetSize()) {
    return *this;
  }

  // recursively get or create nodes
  Node *node;
  const Word &word = source.GetWord(pos);

  Children::iterator iter;
  iter = m_children.find(word);
  if (iter == m_children.end()) {
    node = new Node();
    m_children[word] = node;
  }
  else {
    // found child node
    node = iter->second;
  }
  
  return node->GetOrCreate(source, pos +1);
}

const Node *Node::Get(const Word &word) const
{
  Children::const_iterator iter;
  iter = m_children.find(word);
  if (iter == m_children.end()) {
    return NULL;
  }

  // found child node
  const Node &child = *iter->second;
  return &child;
}

void Node::AddTarget(TargetPhrase *target)
{
  m_tpColl.Add(target);
}

void Node::CreateMemory(const PhraseTable &pt)
{
	Children::iterator iter;
	for (iter = m_children.begin(); iter != m_children.end(); ++iter) {
		Node &node = *iter->second;
		node.CreateMemory(pt);
	}

	m_tpColl.CreateMemory(pt);
}

}

