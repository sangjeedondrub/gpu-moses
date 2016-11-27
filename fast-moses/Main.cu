#include <iostream>
#include "Test.cuh"
#include "MyVocab.h"
#include "PhraseTableMemory.h"

#include "Phrase.cuh"
#include "Scores.cuh"
#include "TargetPhrase.cuh"
#include "TargetPhrases.cuh"

using namespace std;


int main()
{
  cerr << "Starting..." << endl;
  Test();

  FastMoses::MyVocab vocab;
  PhraseTableMemory pt;
  pt.Load("phrase-table");

  cerr << "Finished" << endl;
}
