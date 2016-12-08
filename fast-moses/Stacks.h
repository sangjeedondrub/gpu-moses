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
  :m_vec(true, 0)
  {}

  __host__
  void Init(const Manager &mgr, size_t numStacks);

  __host__ __device__
  Stack &operator[](size_t ind)
  {
    return *m_vec[ind];
  }

  void PrintStacks() const;
protected:
  typedef Vector<Stack*> Vec;
  Vec m_vec;

};

