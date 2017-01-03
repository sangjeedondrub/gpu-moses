#include <iostream>
#include "God.h"

using namespace std;


int main(int argc, char* argv[])
{
  cerr << "Starting..." << endl;

  God god;
  god.Init(argc, argv);



  cerr << "Finished" << endl;
}


