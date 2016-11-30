/*
 * Map.cuh
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */
#pragma once

#include <cassert>
#include <thrust/pair.h>
#include "Set.h"

template<typename Key, typename Value>
class ComparePair
{
public:
	typedef thrust::pair<Key, Value> Pair;

	__device__ bool operator()(const Pair &a, const Pair &b)
	{
	  return a.first < b.first;
	}

};

template<typename Key, typename Value, typename Compare = ComparePair<Key, Value> >
class Map : public Set<thrust::pair<Key, Value>, Compare>
{
public:
  typedef thrust::pair<Key, Value> Pair;
  typedef Set<Pair, Compare> Parent;

  typedef typename Parent::Vec::iterator Iterator;

  Map()
	:Parent()
	{}

  Map(const thrust::host_vector<Pair> &vec)
	:Parent(vec)
	{}

  __host__
  void FindMap(thrust::device_vector<bool> &out, const thrust::device_vector<Pair> &sought) const
  {
    out.resize(sought.size());

    thrust::binary_search(thrust::device,
    									Parent::m_vec.begin(), Parent::m_vec.end(),
                      sought.begin(), sought.end(),
                      out.begin(),
                      Compare());

  }

  __host__
  void FindMap(thrust::host_vector<bool> &out, const thrust::host_vector<Pair> &sought) const
  {
    thrust::device_vector<bool> d_out(sought.size());

    FindMap(d_out, sought);
    out = d_out;
  }

  bool FindMap(const Key &sought) const
  {
    thrust::host_vector<bool> out(1);

    Pair pair(sought, Value());
    thrust::device_vector<Pair> d_sought(1, pair);

    FindMap(out, d_sought);

    assert(out.size() == 1);
    return out[0];

  }

  __host__
  unsigned int LowerBound(const Key &key) const {
    Pair element(key, Value());
    thrust::device_vector<Pair> values(1, element);
    //values[0] = element;
    thrust::device_vector<unsigned int> output(1);

    thrust::lower_bound(
                    Parent::m_vec.begin(), Parent::m_vec.end(),
                    values.begin(), values.end(),
                    output.begin(),
                    Compare() );

    return output[0];
  }

  __device__
  unsigned int LowerBoundDevice(const Key &key) const {

  }

  // assumes there's nothing there. Otherwise it will be a multiset
  __host__
  void Insert(const Key &key, const Value &value)
  {
    Pair element(key, value);
    Iterator iter = thrust::lower_bound(thrust::device,
                    Parent::m_vec.begin(), Parent::m_vec.end(),
                    element,
                    Compare() );
    Parent::m_vec.insert(iter, element);

  }

  __host__
  void Insert(Iterator &iter, Pair &element)
  {
    Parent::m_vec.insert(iter, element);
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


protected:

};


