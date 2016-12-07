/*
 * Map.cuh
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */
#pragma once

#include "Set.h"

template<typename Key, typename Value>
class ComparePair2
{
public:
  typedef thrust::pair<Key, Value> Pair;

  __device__
  bool operator()(const Pair &a, const Pair &b)
  {
    return a.first < b.first;
  }

};

template<typename Key, typename Value, typename Compare = ComparePair2<Key, Value> >
class Map2 : public Set2<thrust::pair<Key, Value>, Compare>
{
public:
  typedef thrust::pair<Key, Value> Pair;
  typedef Set2<Pair, Compare> Parent;

  __host__
  void Insert(const Key &key, const Value &value)
  {
    Pair element(key, value);
    Parent::Insert(element);
  }

  __host__ __device__
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

    for (size_t i = 0; i < Parent::m_arr.GetSize(); ++i) {
      const Pair &pair = Parent::m_arr[i];
      const Key &key = pair.first;
      const Value &value = pair.second;
      strm << key << "=" << value << " ";
    }

    return strm.str();
  }

};


