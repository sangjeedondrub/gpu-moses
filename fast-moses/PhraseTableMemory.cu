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
	if (pos >= words.size()) {
		return *this;
	}

	VOCABID vocabId = words[pos];
	//bool exists = m_children.FindMap(vocabid);
	Children::Iterator iter = m_children.LowerBound(vocabId);
	const Children::Pair &element = *iter;
	VOCABID foundId = element.first;
	if (foundId == vocabId) {
		return *element.second;
	}
	else {
		Node *node = new Node();
		Children::Pair pair(vocabId, node);
		m_children.Insert(iter, pair);
		return *node;
	}
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
		vector<VOCABID> TARGETIds = vocab.GetOrCreateIds(toks[1]);
		vector<SCORE> scores;
		Tokenize(scores, toks[2]);

		Node &node = m_root.AddNode(sourceIds);

	}

	cerr << "finished loading" << endl;
}
