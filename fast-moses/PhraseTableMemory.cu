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
:tps(NULL)
{}

Node::~Node()
{
  const Children::Vec &vec = m_children.GetVec();
  for (size_t i = 0; i < vec.size(); ++i) {
    const Children::Pair &pair = vec[i];
    const Node *node = pair.second;
    delete node;
  }
}

TargetPhrases &Node::GetTargetPhrases()
{
  if (tps == NULL) {
    tps = new TargetPhrases();
  }
  return *tps;
}

Node &Node::AddNode(const std::vector<VOCABID> &words, size_t pos)
{
	//cerr << "pos=" << pos << endl;
	if (pos >= words.size()) {
		//cerr << "found=" << pos << endl;
		return *this;
	}

	const Children::Vec &vec = m_children.GetVec();

	VOCABID vocabId = words[pos];
	Node *node;

	if (m_children.size()) {
		//bool exists = m_children.FindMap(vocabid);
		unsigned int ind = m_children.LowerBound(vocabId);

		if (ind < m_children.size()) {
			const Children::Pair &pair = vec[ind];
			VOCABID foundId = pair.first;
			if (foundId == vocabId) {
				node = pair.second;
			}
			else {
				node = new Node;
				m_children.Insert(vocabId, node);
			}
		}
		else {
			node = new Node;
			m_children.Insert(vocabId, node);
		}
	}
	else {
		node = new Node;
		m_children.Insert(vocabId, node);
	}

	node = &AddNode(words, pos + 1);
	return *node;
}

/////////////////////////////////////////////////////////////////////////////////
PhraseTableMemory::PhraseTableMemory() {
	// TODO Auto-generated constructor stub

}

PhraseTableMemory::~PhraseTableMemory() {
	// TODO Auto-generated destructor stub
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
		cerr << endl << "tp=" << tp->Debug() << endl;

		VOCABID *totVocabId;
		cudaMallocHost(&totVocabId, sizeof(VOCABID));
		checkPhrase<<<1,1>>>(*totVocabId, *tp);
		cudaDeviceSynchronize();
		cerr << "totVocabId=" << *totVocabId << endl;

		SCORE *totScore;
		cudaMallocHost(&totScore, sizeof(SCORE));
		checkTargetPhrase<<<1,1>>>(*totVocabId, *totScore, *tp);
		cudaDeviceSynchronize();
		cerr << "totVocabId=" << *totVocabId << " " << *totScore << endl;
		 */

    size_t *tot;
    cudaMallocHost(&tot, sizeof(size_t));
		checkTargetPhrases<<<1,1>>>(*tot, tps);
		cudaDeviceSynchronize();
    cerr << "tps=" << *tot << endl;

	}

	cerr << "finished loading" << endl;
}
