#include <iostream>
#include "Stack.h"
#include "Hypothesis.h"

using namespace std;

Stack::Stack()
:m_coll(false)
{}

  __device__
void Stack::Add(Hypothesis *hypo)
{
	m_coll.insert(hypo);
}

__global__
void getTotalScore(const Hypothesis *hypo)
{

}

__host__
std::string Stack::Debug() const
{
  std::stringstream strm;
  size_t size = GetSize();
  strm << size << ":";
  for (size_t i = 0; i < size; ++i) {
    cerr << "HH1" << endl;
    const Hypothesis *hypo = m_coll.GetVec()[i];
    cerr << "before" << endl;
    getTotalScore<<<1,1>>>(hypo);
    cerr << "after" << endl;

    //strm << Hypothesis::GetTotalScore(hypo) << " ";
    //strm << (size_t) hypo << " ";
    //strm << i << " ";
  }

  return strm.str();
}
