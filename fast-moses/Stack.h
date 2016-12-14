#pragma once
#include "CUDA/Set.h"
#include "CUDA/Managed.h"
#include "CUDA/Lock.h"
#include "CUDA/Array.h"
#include "CUDA/Vector.h"

class Hypothesis;

class Stack : public Managed
{
public:
  Vector<Hypothesis*> m_arr;

  __host__
  Stack();

  __host__
  ~Stack();

  __device__
	void add(Hypothesis *hypo);

  __device__
  const Vector<Hypothesis*> &getArr() const
  { return m_arr; }

  __device__
  Lock &getLock()
  { return m_lock; }

  __host__
  size_t GetSize() const
  { return m_size; }


  __host__
  std::string Debug() const;

  
  __host__
  Hypothesis *Get(size_t ind) const;
  
protected:
	//Set<Hypothesis*> m_coll;
  size_t m_size;
  
  Lock m_lock;
};
