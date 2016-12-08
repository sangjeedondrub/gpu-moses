#pragma once
#include "CUDA/Managed.h"
#include "CUDA/Array.h"

class Stack;
class Manager;

class Stacks : public Managed
{
public:
  __host__
  void Init(const Manager &mgr, size_t numStacks);

  Stack &operator[](size_t ind)
  {
    return *m_vec[ind];
  }

protected:
  typedef Array<Stack*> Vec;
  Vec m_vec;

};

