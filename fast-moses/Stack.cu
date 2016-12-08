#include "Stack.h"

Stack::Stack()
:m_coll(false)
{}

  __device__
void Stack::Add(Hypothesis *hypo)
{
	m_coll.insert(hypo);
}

__host__
std::string Stack::Debug() const
{
  std::stringstream strm;
  size_t size = GetSize();
  strm << size << ":";
  for (size_t i = 0; i < size; ++i) {
    const Hypothesis *hypo = m_coll.GetVec()[i];
    //strm << (size_t) hypo << " ";
    //strm << i << " ";
  }

  return strm.str();
}
