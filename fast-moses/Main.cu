#include <iostream>
#include "Test.h"
#include "MyVocab.h"
#include "PhraseTableMemory.h"

#include "Phrase.h"
#include "Scores.h"
#include "TargetPhrase.h"
#include "TargetPhrases.h"
#include "Manager.h"

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
	  Manager mgr(line);
  }

  cerr << "Finished" << endl;
}
