#pragma once
#include "CUDA/Set.h"
#include "CUDA/Managed.h"

class Hypothesis;

class Stack : public Managed
{
public:
  __host__
  Stack();

  __device__
	void Add(Hypothesis *hypo);

  __host__
  size_t GetSize() const
  { return m_coll.GetSize(); }

protected:
	Set<Hypothesis*> m_coll;
};
