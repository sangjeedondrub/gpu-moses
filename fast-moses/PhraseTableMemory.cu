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

Node::~Node()
{
  const Children::Vec &vec = m_children.GetVec();
  for (size_t i = 0; i < vec.size(); ++i) {
    const Children::Pair &pair = vec[i];
    const Node *node = pair.second;
    delete node;
  }
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

__global__ void checkTotalVocabId(VOCABID &totVocabId, const TargetPhrase *tp)
{
  size_t size = tp->size();
  totVocabId = size;
  for (size_t i = 0; i < size; ++i) {
    VOCABID id = (*tp)[i];
    totVocabId += id;
  }

  //cudaMemcpy(&totVocabId, &sum, sizeof(VOCABID), cudaMemcpyDeviceToHost);
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
		cerr << "tp=" << tp->Debug() << endl;

		cudaDeviceSynchronize();
		VOCABID *totVocabId;
		cudaMallocHost(&totVocabId, sizeof(VOCABID));
		checkTotalVocabId<<<1,1>>>(*totVocabId, tp);
		cerr << "totVocabId=" << *totVocabId << endl;

		node.GetTargetPhrases().Add(tp);

	}

	cerr << "finished loading" << endl;
}
