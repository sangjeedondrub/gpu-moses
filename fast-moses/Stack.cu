#include <iostream>
#include "Stack.h"
#include "Hypothesis.h"

using namespace std;

__global__
void InitStack(Stack &stack)
{
}


Stack::Stack()
:m_arr(0)
{
  m_size = 0;

  m_arr.Reserve(5000);

  cudaDeviceSynchronize();
  //cerr << "m_arr=" << m_arr << endl;
}

__host__
Stack::~Stack()
{
  for (size_t i = 0; i < m_arr.size(); ++i) {
    Hypothesis *hypo = m_arr[i];
    cudaFree(hypo);
  }
}

__device__
void Stack::add(Hypothesis *hypo)
{
	m_arr.push_back(hypo);
  //(*m_arr)[m_size] = hypo;
	++m_size;
}

__host__
Hypothesis *Stack::Get(size_t ind) const
{
  Hypothesis *ret = m_arr[ind];
  return ret;
  
	//return m_arr[ind];
}

__host__
std::string Stack::Debug() const
{
  std::stringstream strm;
  size_t size = GetSize();
  cerr << "size=" << size << ":";
  for (size_t i = 0; i < size; ++i) {
    cerr << "HH1:" << i << endl;
    const Hypothesis *hypo = Get(i);
    cerr << "HH2:" << hypo << endl;

    SCORE h_s;
    h_s = hypo->GetFutureScore();

    cerr << "HH3:" << h_s << endl;
  }

  return strm.str();
}
