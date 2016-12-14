/*
 * Util.cuh
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */

#pragma once

#include <cassert>
#include <sstream>
#include <iostream>
#include "Vector.h"

template<typename T, typename Compare = thrust::less<T> >
class Set : public Managed
{
public:
  typedef Vector<T, Compare> Vec;

  __host__
  Set()
  :m_vec(0)
  {}

  __device__ __host__
  const Vec &GetVec() const
  { return m_vec; }

  __device__ __host__
  Vec &GetVec()
  { return m_vec; }

  __device__ __host__
  size_t size() const
  { return m_vec.size(); }

  // assumes there's nothing there. Otherwise it will be a multiset
  __device__
  void insert(const T &val)
  {
    thrust::pair<bool, size_t> upper;
    upper = UpperBound(val);
    assert(!upper.first);
    size_t ind = upper.second;
    //std::cerr << "ind=" << ind << std::endl;

    m_vec.insert(ind, val);
  }

  __host__
  void Insert(const T &val)
  {
    thrust::pair<bool, size_t> upper;
    upper = UpperBound(val);
    assert(!upper.first);
    size_t ind = upper.second;
    //std::cerr << "ind=" << ind << std::endl;

    m_vec.Insert(ind, val);
  }

  __host__ __device__
  thrust::pair<bool, size_t> UpperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> upper;
    upper = m_vec.UpperBound(sought);
    return upper;
  }


  __host__
  std::string Debug() const
  {
    return m_vec.Debug();
  }

protected:
  Vec m_vec;

};



