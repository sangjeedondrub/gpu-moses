/*
 * PhraseTableMemory.cpp
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */
#include <iostream>
#include <string>
#include "PhraseTableMemory.h"
#include "MyVocab.h"
#include "InputFileStream.h"
#include "Util.h"

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/binary_search.h>
#include <thrust/execution_policy.h>

using namespace std;

Node::Node()
:m_tps(NULL)
{}

Node::~Node()
{
  const Children::Vec &vec = m_children.GetVec();
  for (size_t i = 0; i < vec.GetSize(); ++i) {
    const Children::Pair &pair = vec[i];
    const Node *node = pair.second;
    delete node;
  }
}

TargetPhrases &Node::GetTargetPhrases()
{
  if (m_tps == NULL) {
    cudaMallocManaged(&m_tps, sizeof(TargetPhrases));
  }
  return *m_tps;
}

__host__
Node &Node::AddNode(const std::vector<VOCABID> &words, size_t pos)
{
	//cerr << "pos=" << pos << endl;
	if (pos >= words.size()) {
		//cerr << "found=" << pos << endl;
		return *this;
	}

	VOCABID vocabId = words[pos];
	Node *node;

	thrust::pair<bool, size_t> upper = m_children.UpperBound(vocabId);
	if (upper.first) {
	  size_t ind = upper.second;
	  node = m_children.GetValue(ind);
	}
	else {
	  cudaMallocManaged(&node, sizeof(Node));
    m_children.Insert(vocabId, node);
	}

	node = &node->AddNode(words, pos + 1);
	return *node;
}

__device__
const TargetPhrases *Node::Lookup(const Phrase &phrase, size_t start, size_t end, size_t pos) const
{
  if (pos > end) {
    return m_tps;
  }

  VOCABID vocabId = phrase[pos];
  thrust::pair<bool, size_t> upper = m_children.UpperBound(vocabId);
  return (const TargetPhrases *) m_children.size();

  if (upper.first) {
    const Node *node = m_children.GetValue(upper.second);
    assert(node);
    return node->Lookup(phrase, start, end, pos + 1);
  }
  else {
    return (const TargetPhrases *) 0x987;
    return NULL;
  }
}

/////////////////////////////////////////////////////////////////////////////////
PhraseTableMemory::PhraseTableMemory()
{
  //m_root = new Node();
}

PhraseTableMemory::~PhraseTableMemory() {
	//delete m_root;
}

void PhraseTableMemory::Load(const std::string &path)
{
	cerr << "begin loading" << endl;
	FastMoses::InputFileStream strm(path);

	FastMoses::MyVocab &vocab = FastMoses::MyVocab::Instance();

	std::string line;
	while (getline(strm, line)) {
		//cerr << line << endl;
		std::vector<std::string> toks;
		TokenizeMultiCharSeparator(toks, line, "|||");
		/*
		for (size_t i = 0; i < toks.size(); ++i) {
			cerr << "\t" << toks[i]<< endl;
		}
		*/

		vector<VOCABID> sourceIds = vocab.GetOrCreateIds(toks[0]);
		Node &node = m_root.AddNode(sourceIds);

		TargetPhrase *tp = TargetPhrase::CreateFromString(toks[1]);
		tp->GetScores().CreateFromString(toks[2]);
		
    TargetPhrases &tps = node.GetTargetPhrases();
		tps.Add(tp);

		/*
		cerr << endl;
		cerr << "node=" << &node << " " << node.GetChildren().GetSize() << endl;
		cerr << "tp=" << tp->Debug() << endl;
    */

    char *str;
    cudaMallocHost(&str, 10000);

		checkPhrase<<<1,1>>>(str, *tp);
		cudaDeviceSynchronize();
		//cerr << "totVocabId=" << str << endl;

		checkTargetPhrase<<<1,1>>>(str, *tp);
		cudaDeviceSynchronize();
		//cerr << "totVocabId=" << str << endl;

		checkTargetPhrases<<<1,1>>>(str, tps);
		cudaDeviceSynchronize();
    //cerr << "tps=" << str << endl;

    cudaFree(str);
	}

	cerr << "root=" << m_root.GetChildren().Debug() << endl;
	cerr << "finished loading" << endl;
}

__device__
const TargetPhrases *PhraseTableMemory::Lookup(const Phrase &phrase, size_t start, size_t end) const
{
  return m_root.Lookup(phrase, start, end, start);
}

