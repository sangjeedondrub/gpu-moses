#pragma once
#include <thrust/device_vector.h>
#include "CUDA/Managed.h"

class Stack;
class Manager;

class Stacks : public Managed
{
public:
  void Init(const Manager &mgr, size_t numStacks);

  Stack &operator[](size_t ind)
  {
    return *m_vec[ind];
  }

protected:
  typedef thrust::device_vector<Stack*> Vec;
  Vec m_vec;

};

