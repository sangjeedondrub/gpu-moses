#pragma once
#include "CUDA/Set.h"
#include "CUDA/Managed.h"
#include "CUDA/Lock.h"

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

  __device__
  const Set<Hypothesis*> &GetSet() const
  { return m_coll; }

  __device__
  Lock &GetLock()
  { return m_lock; }

protected:
	Set<Hypothesis*> m_coll;

  Lock m_lock;
};
