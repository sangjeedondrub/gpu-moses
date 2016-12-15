#include <iostream>
#include "Stack.h"
#include "Hypothesis.h"

using namespace std;


Stack::Stack()
:m_coll()
{
  m_coll.GetVec().Reserve(5000);

  cudaDeviceSynchronize();
  //cerr << "m_arr=" << m_arr << endl;
}

__host__
Stack::~Stack()
{
  for (size_t i = 0; i < m_coll.size(); ++i) {
    Hypothesis *hypo = m_coll.GetVec()[i];
    cudaFree(hypo);
  }
}

__device__
void Stack::add(Hypothesis *hypo)
{
  thrust::pair<bool, size_t> upper = m_coll.upperBound(hypo);
  if (upper.first) {
    // same hypo exist
    const Hypothesis *otherHypo = m_coll.GetVec()[upper.second];

    SCORE newScore = hypo->getFutureScore();
    SCORE otherScore = otherHypo->getFutureScore();

    if (newScore > otherScore) {
      // new hypo is better
      delete otherHypo;
      m_coll.GetVec()[upper.second] = hypo;
    }
    else {
      // existing hypo is better
      delete hypo;
    }
  }
  else {
    m_coll.insert(hypo);
    //(*m_arr)[m_size] = hypo;
  }
}

__host__
std::string Stack::Debug() const
{
  std::stringstream strm;
  size_t size = GetSize();
  cerr << "size=" << size << ":";
  for (size_t i = 0; i < size; ++i) {
    cerr << "HH1:" << i << endl;
    const Hypothesis *hypo = m_coll.GetVec()[i];
    cerr << "HH2:" << hypo << endl;

    SCORE h_s;
    h_s = hypo->GetFutureScore();

    cerr << "HH3:" << h_s << endl;
    cerr << "HH4:" << hypo->Debug() << endl;
  }

  return strm.str();
}
