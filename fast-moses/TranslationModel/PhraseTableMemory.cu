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
#include "../System.h"
#include "../FF/FeatureFunctions.h"

using namespace std;




/////////////////////////////////////////////////////////////////////////////////
PhraseTableMemory::PhraseTableMemory(size_t startInd, const std::string &line)
:FeatureFunction(startInd, line)
,m_root(NULL)
{
  classId = FeatureFunction::ClassId::PhraseDictionaryMemory;

  ReadParameters();

}

PhraseTableMemory::~PhraseTableMemory() {
	//delete m_root;
}

void PhraseTableMemory::Load(System &system)
{
	cerr << "begin loading" << endl;
	InputFileStream strm(m_path);

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
		Phrase sourcePhrase(sourceIds);
		Node &node = m_root.AddOrCreateNode(sourceIds, NULL);

		/*
		cerr << "node=" << &node << " "
		    << node.GetChildren().GetSize() << " "
		    << endl;
    */
		TargetPhrase *tp = TargetPhrase::CreateFromString(system, toks[1]);
		tp->GetScores().CreateFromString(system, *this, toks[2], true);
		system.featureFunctions.EvaluateInIsolation(sourcePhrase, *tp);
		
    if (node.tps == NULL) {
      node.tps = new TargetPhrases();
    }
		node.tps->Add(tp);

		/*
		cerr << endl;
		cerr << "node=" << &node << " " << node.GetChildren().GetSize() << endl;
		cerr << "tp=" << tp->Debug() << endl;
    */

		/*
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
    */
	}

	//cerr << "root=" << m_root.GetChildren().Debug() << endl;
	cerr << "finished loading" << endl;
}

void PhraseTableMemory::SetParameter(const std::string& key, const std::string& value)
{
  if (key == "input-factor") {

  }
  else if (key == "output-factor") {

  }
  else if (key == "table-limit") {

  }
  else if (key == "path") {
    m_path = value;
  }
  else {
    FeatureFunction::SetParameter(key, value);
  }
}

__device__
const TargetPhrases *PhraseTableMemory::Lookup(const Phrase &phrase, size_t start, size_t end) const
{
  return m_root.Lookup(phrase, start, end, start);
}

