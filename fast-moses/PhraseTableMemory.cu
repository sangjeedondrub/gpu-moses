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

	VOCABID vocabId = words[pos];
	//bool exists = m_children.FindMap(vocabid);
	cerr << "HH1:" << vocabId << endl;
	Children::Iterator iter = m_children.LowerBound(vocabId);
	cerr << "HH2" << endl;
	const Children::Pair &element = *iter;
	cerr << "HH2.1" << endl;
	VOCABID foundId = element.first;
	cerr << "HH2.2" << endl;
	Node *node;

	cerr << "HH3" << endl;
	if (foundId == vocabId) {
		cerr << "HH4" << endl;
		node = element.second;
		assert(node);
		cerr << "HH5" << endl;
	}
	else {
		cerr << "HH6" << endl;
		node = new Node();
		cerr << "HH7" << endl;
		Children::Pair pair(vocabId, node);
		cerr << "HH8" << endl;
		m_children.Insert(iter, pair);
		cerr << "HH9" << endl;
	}
	cerr << "HH1" << endl;
	return node->AddNode(words, pos + 1);
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
