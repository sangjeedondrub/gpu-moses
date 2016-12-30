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

istream &GetInput(const System &system)
{
  if (system.options.input.input_file_path.empty()) {
    return cin;
  }
  else {
    ifstream *inStrm = new ifstream();
    inStrm->open(system.options.input.input_file_path.c_str());
    return *inStrm;
  }
}

int main(int argc, char* argv[])
{
  cerr << "Starting..." << endl;
  //Test();

  Parameter params;
  params.LoadParam(argc, argv);

  System *system = new System(params);

  FastMoses::MyVocab vocab;

  cerr << "Start Decoding:" << endl;

  istream &inStrm = GetInput(*system);
  string line;
  while (getline(inStrm, line)) {
	  Manager *mgr = new Manager(*system, line);
	  mgr->Process();
  }

  cerr << "Finished" << endl;
}
