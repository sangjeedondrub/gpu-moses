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
#include "Array.h"

template<typename T, typename Compare = thrust::less<T> >
class Set : public Managed
{
public:
  typedef Array<T, Compare> Vec;

  __host__
  Set(bool managed)
  :m_arr(managed, 0)
  {}

  __host__ __device__
  const Vec &GetVec() const
  { return m_arr; }

  __device__
  size_t size() const
  { return m_arr.size(); }

  __host__
  size_t GetSize() const
  { return m_arr.GetSize(); }

  // assumes there's nothing there. Otherwise it will be a multiset
  __device__
  void insert(const T &val)
  {
    thrust::pair<bool, size_t> upper;
    upper = UpperBound(val);
    assert(!upper.first);
    size_t ind = upper.second;
    //std::cerr << "ind=" << ind << std::endl;

    m_arr.insert(ind, val);
  }

  __host__
  void Insert(const T &val)
  {
    thrust::pair<bool, size_t> upper;
    upper = UpperBound(val);
    assert(!upper.first);
    size_t ind = upper.second;
    //std::cerr << "ind=" << ind << std::endl;

    m_arr.Insert(ind, val);
  }

  __host__ __device__
  thrust::pair<bool, size_t> UpperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> upper;
    upper = m_arr.UpperBound(sought);
    return upper;
  }


  __host__
  std::string Debug() const
  {
    return m_arr.Debug();
  }

protected:
  Vec m_arr;

};



