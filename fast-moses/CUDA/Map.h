/*
 * Map.cuh
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */
#pragma once

#include "Set.h"

template<typename Key, typename Value>
class CompareMap
{
public:
  typedef thrust::pair<const Key, Value> Pair;

  __host__ __device__
  bool operator()(const Pair &a, const Pair &b)
  {
    return a.first < b.first;
  }

};

template<typename Key, typename Value, typename CompareDevice = CompareMap<Key, Value>, typename CompareHost = CompareDevice >
class Map : public Set<thrust::pair<Key, Value>, CompareDevice, CompareHost>
{
public:
  typedef thrust::pair<Key, Value> Pair;
  typedef Set<Pair, CompareDevice, CompareHost> Parent;

  Map()
  :Parent()
  {}

  __device__
  const Value &GetValue(size_t ind) const
  {
    const Pair &pair = Parent::m_vec[ind];
    return pair.second;
  }

  __host__ __device__
  Value &GetValue(size_t ind)
  {
    Pair &pair = Parent::m_vec[ind];
    return pair.second;
  }

  __host__
  const Pair &Insert(const Key &key, const Value &value)
  {
    Pair element(key, value);
    const Pair &ret = Parent::Insert(element);
    return ret;
  }

  __device__
  thrust::pair<bool, size_t> upperBound(const Key &sought) const
  {
    Pair pair(sought, Value());

    thrust::pair<bool, size_t> upper;
    upper = Parent::upperBound(pair);
    return upper;
  }

  __host__
  thrust::pair<bool, size_t> UpperBound(const Key &sought) const
  {
    Pair pair(sought, Value());

    thrust::pair<bool, size_t> upper;
    upper = Parent::UpperBound(pair);
    return upper;
  }

  __host__
  std::string Debug() const
  {
    std::ostringstream strm;

    for (size_t i = 0; i < Parent::m_vec.size(); ++i) {
      const Pair &pair = Parent::m_vec[i];
      const Key &key = pair.first;
      const Value &value = pair.second;
      strm << key << "=" << value << " ";
    }

    return strm.str();
  }

};


