#pragma once
#include "CUDA/Set.h"
#include "CUDA/Managed.h"
#include "CUDA/Lock.h"
#include "CUDA/Array.h"
#include "CUDA/Vector.h"
#include "Hypothesis.h"

class Manager;

class Stack : public Managed
{
public:
  //char debugStr[2000];

  __host__
  Stack(const Manager &mgr);

  __host__
  ~Stack();

  __device__
	void add(Hypothesis *hypo);

  __device__
  void prune(const Manager &mgr);

  __device__
  const Vector<Hypothesis*> &GetVec() const
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
	//Set<Hypothesis*> m_coll;
  Set<Hypothesis*, HypothesisRecombinationOrderer> m_coll;
  size_t m_tolerance;
  
  Lock m_lock;
};
