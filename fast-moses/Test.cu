#include <array>
#include <iterator>
#include <iostream>
#include <thrust/binary_search.h>
#include "Test.h"
#include "Phrase.h"
#include "CUDA/Set.h"
#include "CUDA/Map.h"
#include "CUDA/Managed.h"
#include "CUDA/Vector.h"

using namespace std;

#define N 10
#define N_SOUGHT 2

//////////////////////////////////////////////////////

class C2 : public Managed
{
public:
	int i;
	int arr[N] = {2,4,6,8,10,12,14,16,18,20};
	int out[3];

	C2(int v)
	{
		i = v;
	}

	__device__ void Add(int v)
	{
		i += v;
	}

	void Search()
	{
		int sought[3] = {4, 5, 6};

	    thrust::binary_search(std::begin(arr), std::end(arr),
	    		std::begin(sought), std::end(sought),
	    		std::begin(out));

	}
};

__global__ void Temp(C2 &o)
{
  o.Add(2);
  //o.Search();
}

__global__ void KernelC2(C2 &o)
{
  o.Add(3);
  //Temp<<<2,1>>>(o);
}

void Test2()
{
  //KernelTCLass<<<1,1>>>();
  //KernelTAdd<<<1,1>>>(3);
  C2 *oHeap = new C2(6);
  cudaDeviceSynchronize();
  cerr << "oHeap=" << oHeap->i << endl;

  KernelC2<<<1,1>>>(*oHeap);
  cudaDeviceSynchronize();
  cerr << "oHeap=" << oHeap->i << endl;

  Temp<<<2,1>>>(*oHeap);
  //oHeap->Add<<<1,1>>>(4);

  oHeap->Search();
  for (size_t i = 0; i < 3; ++i) {
	  cerr << oHeap->out[i] << " ";
  }
  cerr << endl;

  delete oHeap;

  C2 oStack(7);
  cerr << "oStack=" << oStack.i << endl;
  //oStack.Add(4);
  //cerr << "oStack=" << oStack.i << endl;

}

//////////////////////////////////////////////////////

void Test3()
{
  Phrase *input = Phrase::CreateFromString("dast ist eine kleines haus");
  cerr << "input=" << input->Debug() << endl;
  
  char *str;
  cudaMallocHost(&str, 10000);

  checkPhrase<<<1,1>>>(str, *input);
  cudaDeviceSynchronize();
  cerr << "checkId=" << str << endl;

  cudaFree(str);

  //exit(0);
}


void Test1()
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
  /*
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
*/
}

//////////////////////////
template<typename T>
__global__
void Resize(Vector<T> &arr)
{
  thrust::pair<bool, size_t> found;
  found = arr.UpperBound(100);

}


void Test5()
{
  Set<int> s;

  s.Insert(4);
  s.Insert(3);
  s.Insert(5);
  s.Insert(2);

  cerr << "set2=" << s.Debug() << endl;
}

void Test6()
{
  Map<int, float> m;
  m.Insert(4, 5.45);
  m.Insert(6, 5654.34);
  m.Insert(3, 1.99);

  cerr << "map2=" << m.Debug() << endl;
}

void Test()
{
  //Test1();
  //Test2();
  //Test3();
  //Test4();
  //Test5();
  Test6();
}
