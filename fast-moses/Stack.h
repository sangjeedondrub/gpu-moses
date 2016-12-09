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
  { return m_size; }

  __device__
  Lock &GetLock()
  { return m_lock; }

  __host__
  std::string Debug() const;

   __device__
  const Hypothesis **GetArr() const
  { return m_arr; }
  
  __host__
  Hypothesis *Get(size_t ind) const;
  
protected:
	//Set<Hypothesis*> m_coll;
  Hypothesis **m_arr;
  size_t m_size;
  
  Lock m_lock;
};
