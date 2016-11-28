#include <iostream>
#include "Test.h"
#include "Managed.h"
#include "CUDA/Set.h"
#include "CUDA/Map.h"

using namespace std;

//////////////////////////////////////////////////////

class C2 : public Managed
{
public:
	int i;

	C2(int v)
	{
		i = v;
	}

	__device__ void Add(int v)
	{
		i += v;
	}

};

__global__ void Temp(C2 &o)
{
  o.Add(2);
}

__global__ void KernelC2(C2 &o)
{
  o.Add(3);
  Temp<<<2,1>>>(o);
}

void Test2()
{
  //KernelTCLass<<<1,1>>>();
  //KernelTAdd<<<1,1>>>(3);
  C2 *oCPU = new C2(6);
  cudaDeviceSynchronize();
  cerr << "oCPU=" << oCPU->i << endl;

  KernelC2<<<1,1>>>(*oCPU);
  cudaDeviceSynchronize();
  cerr << "oCPU=" << oCPU->i << endl;

  Temp<<<2,1>>>(*oCPU);
  //oCPU->Add<<<1,1>>>(4);

}

//////////////////////////////////////////////////////
#define N 10
#define N_SOUGHT 2

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
  std::cerr << "SET:" << std::endl;
  Set<int> myset(data);
  myset.Find(out, sought);
  Print(std::cerr, out);

  bool found = myset.Find(3);
  bool found2 = myset.Find(4);
  std::cerr << "found:" << found << " " << found2 << std::endl;

  // INSERT
  std::cerr << "BEFORE:" << myset.Debug() << std::endl;
  myset.Insert(5);
  std::cerr << "AFTER:" << myset.Debug() << std::endl;

  // ERASE
  myset.Erase(14);
  std::cerr << "AFTER:" << myset.Debug() << std::endl;

  myset.Erase(11);
  std::cerr << "AFTER:" << myset.Debug() << std::endl;

	// MAP

  std::cerr << "MAP:" << std::endl;
  typedef thrust::pair<int, float> Pair;
	thrust::host_vector<Pair> dataMap(5);
	dataMap[0] = Pair(4, 2342.4f);
	dataMap[1] = Pair(6, 6756.77f);
	dataMap[2] = Pair(7, -34.3434);
	dataMap[3] = Pair(10, 43.33f);
	dataMap[4] = Pair(34545, -343.7675f);

 	Map<int, float, ComparePair<int, float> > mymap(dataMap);
  std::cerr << "BEFORE:" << mymap.Debug() << std::endl;

	found = mymap.FindMap(3);
  found2 = mymap.FindMap(4);
  std::cerr << "found:"
  		<< found << " "
  		<< found2 << " "
  		<< mymap.FindMap(5) << " "
  		<< mymap.FindMap(6) << " "
  		<< mymap.FindMap(7) << " "
  		<< mymap.FindMap(8) << " "
  		<< std::endl;

	mymap.Insert(9, -323.2);
	mymap.Insert(5, -999.2);

  std::cerr << "AFTER:" << mymap.Debug() << std::endl;

  Test2();
}
