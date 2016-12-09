#include <iostream>
#include "Stack.h"
#include "Hypothesis.h"

using namespace std;

Stack::Stack()
{
  cudaMalloc(&m_arr, sizeof(Hypothesis*) * 5000);
  cudaMemset(m_arr, 0, sizeof(Hypothesis*) * 5000);
  m_size = 0;
  //cerr << "m_arr=" << m_arr << endl;
}

__device__
void Stack::Add(Hypothesis *hypo)
{
	m_arr[m_size] = hypo;
	++m_size;
}

__host__
Hypothesis *Stack::Get(size_t ind) const
{
  Hypothesis *ret;
  //cudaMalloc(&ret, sizeof(Hypothesis*));

  cudaMemcpy(&ret, &m_arr[ind], sizeof(Hypothesis *), cudaMemcpyDeviceToHost);
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

    //getTotalScore<<<1,1>>>(hypo);
    //strm << hypo->GetFutureScore() << " ";
    //cerr << "HH3:" << hypo->GetFutureScore() << endl;
    //strm << Hypothesis::GetTotalScore(hypo) << " ";
    //strm << (size_t) hypo << " ";
    //strm << i << " ";
  }

  return strm.str();
}
