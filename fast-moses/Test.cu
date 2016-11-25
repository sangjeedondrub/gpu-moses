#include "Test.cuh"
#include "CUDA/Set.cuh"
#include "CUDA/Map.cuh"

#define N 10
#define N_SOUGHT 2

using namespace std;

void Test()
{
  thrust::host_vector<int> data(N), sought(N_SOUGHT);
  thrust::host_vector<bool> out;


  // fill the arrays 'a' and 'b' on the CPU
  for (int i=0; i<N; i++) {
    data[i] = i * 2;
  }

  sought[0] = 4;
  sought[1] = 5;

  // SET
  cerr << "SET:" << endl;
  Set<int> myset(data);
  myset.Find(out, sought);
  Print(cerr, out);

  bool found = myset.Find(3);
  bool found2 = myset.Find(4);
  cerr << "found:" << found << " " << found2 << endl;

  // INSERT
  cerr << "BEFORE:" << myset.Debug() << endl;
  myset.Insert(5);
  cerr << "AFTER:" << myset.Debug() << endl;

  // ERASE
  myset.Erase(14);
  cerr << "AFTER:" << myset.Debug() << endl;

  myset.Erase(11);
  cerr << "AFTER:" << myset.Debug() << endl;

	// MAP

  cerr << "MAP:" << endl;
  typedef thrust::pair<int, float> Pair;
	thrust::host_vector<Pair> dataMap(5);
	dataMap[0] = Pair(4, 2342.4f);
	dataMap[1] = Pair(6, 6756.77f);
	dataMap[2] = Pair(7, -34.3434);
	dataMap[3] = Pair(10, 43.33f);
	dataMap[4] = Pair(34545, -343.7675f);

 	Map<int, float, ComparePair<int, float> > mymap(dataMap);
  cerr << "BEFORE:" << mymap.Debug() << endl;

	found = mymap.FindMap(3);
  found2 = mymap.FindMap(4);
  cerr << "found:"
  		<< found << " "
  		<< found2 << " "
  		<< mymap.FindMap(5) << " "
  		<< mymap.FindMap(6) << " "
  		<< mymap.FindMap(7) << " "
  		<< mymap.FindMap(8) << " "
  		<< endl;

	mymap.Insert(9, -323.2);
	mymap.Insert(5, -999.2);

  cerr << "AFTER:" << mymap.Debug() << endl;

}
