/*
 * Main.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#include <iostream>
#include <string>
#include "Sentence.h"
#include "System.h"
#include "Util.h"
#include "Search/Manager.h"
#include "CUDA/CUDA.cuh"

using namespace std;
using namespace FastMoses;

int main(int argc, char** argv)
{
  Fix(cerr, 3);

  System system;
  system.timer.start("Starting...");

  system.Init(argc, argv);

  system.timer.check("Ready for input:");

  vector<SCORE> weights(6);
  weights[0] = 0.1;
  weights[1] = 0.2;
  weights[2] = 0.3;
  weights[3] = 0.4;
  weights[4] = 0.5;
  weights[5] = 0.6;

  InitGPU(weights);

  string line;
  while (getline(system.GetInputStream(), line)) {
    if (line == "EXIT") {
      break;
    }

    Sentence *input = Sentence::CreateFromString(line);
    cerr << "input=" << input->Debug() << endl;

    Manager manager(*input, system);


    cout << endl;

    cerr << "Ready for input:" << endl;
  }

  FinalizeGPU();

  PrintUsage(std::cerr);
  system.timer.check("Finished");
  
  return 0;
}

