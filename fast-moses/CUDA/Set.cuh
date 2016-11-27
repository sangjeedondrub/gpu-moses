/*
 * Util.cuh
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */

#pragma once

#include <sstream>
#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/binary_search.h>
#include <thrust/execution_policy.h>

template<typename T>
void Print(std::ostream &out, const thrust::host_vector<T> &vec)
{
  for (size_t i = 0; i < vec.size(); ++i) {
    out << vec[i] << " ";
  }
  out << std::endl;
}

/////////////////////////////////////////////////////////////////////////////////////

template<typename T, typename Compare = thrust::less<T> >
class Set
{
public:
  typedef thrust::device_vector<T> Vec;

  Set()
  {}

  Set(const thrust::host_vector<T> &vec)
  :m_vec(vec)
  {

  }

  void Find(thrust::device_vector<bool> &out, const thrust::device_vector<T> &sought) const
  {
    out.resize(sought.size());
    thrust::binary_search(m_vec.begin(), m_vec.end(),
                      sought.begin(), sought.end(),
                      out.begin(),
                      Compare() );
  }

  void Find(thrust::host_vector<bool> &out, const thrust::host_vector<T> &sought) const
  {
    thrust::device_vector<bool> d_out(sought.size());
    Find(d_out, sought);
    out = d_out;
  }

  bool Find(const T &sought) const
  {
    thrust::host_vector<T> d_sought(1, sought);
    thrust::host_vector<bool> out(1);

    Find(out, d_sought);

    assert(out.size() == 1);
    return out[0];
  }

  // assumes there's nothing there. Otherwise it will be a multiset
  void Insert(const T &val)
  {
    typedef typename thrust::device_vector<T>::iterator Iter;

  	Iter iter = thrust::lower_bound(thrust::device,
  												m_vec.begin(), m_vec.end(),
  												val,
  												Compare() );
    m_vec.insert(iter, val);
  }

  // assume key is in there. Otherwise will delete the next 1 along!
  void Erase(const T &val)
  {
    typedef typename thrust::device_vector<T>::iterator Iter;

  	Iter iter = thrust::lower_bound(thrust::device,
  												m_vec.begin(), m_vec.end(),
  												val,
  												Compare() );
    m_vec.erase(iter);
  }

  std::string Debug() const
  {
    std::ostringstream strm;
    Print<T>(strm, m_vec);
    return strm.str();
  }


protected:
  thrust::device_vector<T> m_vec;

};




