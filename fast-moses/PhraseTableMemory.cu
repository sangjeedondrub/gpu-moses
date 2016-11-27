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

Node &Node::AddNode(const std::vector<VOCABID> &words, size_t pos)
{
	cerr << "pos=" << pos << endl;
	if (pos >= words.size()) {
		return *this;
	}

	const Children::Vec &vec = m_children.GetVec();

	VOCABID vocabId = words[pos];
	Node *node;

	if (m_children.size()) {
		//bool exists = m_children.FindMap(vocabid);
		cerr << "HH1:" << vocabId << endl;
		unsigned int ind = m_children.LowerBound(vocabId);
		cerr << "HH2:" << ind << endl;

		if (ind < m_children.size()) {
			const Children::Pair &pair = vec[ind];
			VOCABID foundId = pair.first;
			if (foundId == vocabId) {
				node = pair.second;
			}
			else {
				cerr << "HH77" << endl;
				node = new Node;
				m_children.Insert(vocabId, node);
			}
		}
		else {
			cerr << "HH88" << endl;
			node = new Node;
			m_children.Insert(vocabId, node);
		}
	}
	else {
		cerr << "HH99" << endl;
		node = new Node;
		m_children.Insert(vocabId, node);
	}

	node = &AddNode(words, pos + 1);
	return *node;
}

void Node::AddTargetPhrase(const char *str)
{
	tps.push_back(tps.size() * 2);
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
		cerr << line << endl;
		std::vector<std::string> toks;
		TokenizeMultiCharSeparator(toks, line, "|||");
		for (size_t i = 0; i < toks.size(); ++i) {
			cerr << "\t" << toks[i]<< endl;
		}

		vector<VOCABID> sourceIds = vocab.GetOrCreateIds(toks[0]);
		vector<VOCABID> targetIds = vocab.GetOrCreateIds(toks[1]);
		vector<SCORE> scores;
		Tokenize(scores, toks[2]);

		Node &node = m_root.AddNode(sourceIds);
		//node.AddTargetPhrase("dsds");

	}

	cerr << "finished loading" << endl;
}
