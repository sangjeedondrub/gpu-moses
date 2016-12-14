#pragma once
#include "CUDA/Managed.h"
#include "CUDA/Vector.h"
 
class Stack;
class Manager;

class Stacks : public Managed
{
public:
  __host__
  Stacks()
  :m_vec(0)
  {}

  __host__
  void Init(const Manager &mgr, size_t numStacks);

  __device__
  Stack &operator[](size_t ind)
  {  return *m_vec[ind]; }

  __host__
  const Stack &Get(size_t ind) const
  { return *m_vec.Get(ind); }

  __host__
  Stack &Get(size_t ind)
  { return *m_vec.Get(ind); }
  
  __host__
  const Stack &Back() const
  { return *m_vec.Get(m_vec.size() - 1); }

  void PrintStacks() const;
protected:
  typedef Vector<Stack*> Vec;
  Vec m_vec;

};

