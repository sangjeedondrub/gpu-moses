#include <iostream>
#include "Test.cuh"
#include "MyVocab.h"
#include "PhraseTableMemory.h"

using namespace std;


int main()
{
  cerr << "Starting..." << endl;
  Test();

  FastMoses::MyVocab vocab;
  PhraseTableMemory pt;
  pt.Load("pt.txt");

  cerr << "Finished" << endl;
}
