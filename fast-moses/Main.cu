#include <iostream>
#include "Test.h"
#include "MyVocab.h"
#include "PhraseTableMemory.h"

#include "Phrase.h"
#include "Scores.h"
#include "TargetPhrase.h"
#include "TargetPhrases.h"

using namespace std;


int main()
{
  cerr << "Starting..." << endl;
  Test();

  FastMoses::MyVocab vocab;
  PhraseTableMemory pt;
  pt.Load("phrase-table");

  string line;
  while (getline(cin, line)) {
	  Phrase *input = Phrase::CreateFromString(line);
	  cerr << "input=" << input->Debug() << endl;

	  delete input;
  }

  cerr << "Finished" << endl;
}
