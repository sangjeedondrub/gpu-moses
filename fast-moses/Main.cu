#include <iostream>
#include "Test.h"
#include "MyVocab.h"
#include "PhraseTableMemory.h"

#include "Phrase.h"
#include "Scores.h"
#include "TargetPhrase.h"
#include "TargetPhrases.h"
#include "Manager.h"
#include "CUDA/Array.h"

using namespace std;


int main()
{
  cerr << "Starting..." << endl;
  Test();

  FastMoses::MyVocab vocab;
  PhraseTableMemory *pt = new PhraseTableMemory();
  pt->Load("phrase-table");

  cerr << "Start Decoding:" << endl;
  string line;
  while (getline(cin, line)) {
	  Manager *mgr = new Manager(line, *pt);
	  mgr->Process();
  }

  cerr << "Finished" << endl;
}
