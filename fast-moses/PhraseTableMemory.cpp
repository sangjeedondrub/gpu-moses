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

using namespace std;

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

	}

	cerr << "finished loading" << endl;
}
