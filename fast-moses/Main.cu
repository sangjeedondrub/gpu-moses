#include <iostream>
#include "Test.cuh"
#include "MyVocab.h"

using namespace std;


int main()
{
  cerr << "Starting..." << endl;
  Test();

  FastMoses::MyVocab vocab;


  cerr << "Finished" << endl;
}
