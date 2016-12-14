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
  __host__
  Stack();

  __host__
  ~Stack();

  __device__
	void add(Hypothesis *hypo);

  __device__
  const Vector<Hypothesis*> &getArr() const
  { return m_coll.GetVec(); }

  __device__
  Lock &getLock()
  { return m_lock; }

  __host__
  size_t GetSize() const
  { return m_coll.size(); }


  __host__
  std::string Debug() const;


protected:
  //Vector<Hypothesis*> m_arr;
	Set<Hypothesis*> m_coll;
  
  Lock m_lock;
};
