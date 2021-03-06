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

template<typename T, typename CompareDevice = thrust::less<T>, typename CompareHost = CompareDevice >
class Set : public Managed
{
public:
  typedef Vector<T> Vec;

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
  size_t insert(const T &val)
  {
    thrust::pair<bool, size_t> upper;
    upper = upperBound(val);
    assert(!upper.first);
    size_t ind = upper.second;
    //std::cerr << "ind=" << ind << std::endl;

    size_t ret = m_vec.insert(ind, val);
    return ret;
  }

  __host__
  size_t Insert(const T &val)
  {
    thrust::pair<bool, size_t> upper;
    upper = UpperBound(val);
    assert(!upper.first);
    size_t ind = upper.second;
    //std::cerr << "ind=" << ind << std::endl;

    size_t ret = m_vec.Insert(ind, val);
    return ret;
  }

  template<typename CC = CompareDevice >
  __device__
  thrust::pair<bool, size_t> upperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> upper;
    upper = m_vec.upperBound<CC>(sought);
    return upper;
  }


  template<typename CC = CompareHost >
  __host__
  thrust::pair<bool, size_t> UpperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> upper;
    upper = m_vec.UpperBound<CC>(sought);
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



