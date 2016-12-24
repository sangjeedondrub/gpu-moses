#include <fstream>
#include <iostream>
#include "Test.h"
#include "MyVocab.h"
#include "TranslationModel/PhraseTableMemory.h"

#include "System.h"
#include "Parameter.h"
#include "Phrase.h"
#include "Scores.h"
#include "TargetPhrase.h"
#include "TargetPhrases.h"
#include "Manager.h"
#include "CUDA/Vector.h"

using namespace std;

istream &GetInput()
{
  //return cin;

  ifstream *inStrm = new ifstream();
  inStrm->open("in");
  return *inStrm;

}

int main(int argc, char* argv[])
{
  cerr << "Starting..." << endl;
  Test();

  Parameter params;
  params.LoadParam(argc, argv);

  System *system = new System(params);

  FastMoses::MyVocab vocab;

  cerr << "Start Decoding:" << endl;

  istream &inStrm = GetInput();
  string line;
  while (getline(inStrm, line)) {
	  Manager *mgr = new Manager(*system, line);
	  mgr->Process();
  }

  cerr << "Finished" << endl;
}
