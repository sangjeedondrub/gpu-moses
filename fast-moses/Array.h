/*
 * Array.h
 *
 *  Created on: 29 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <cuda.h>
#include "Managed.h"

template<typename T>
class Array : public Managed
{
public:
  __device__ Array(size_t size = 0, const T &val = T())
  {
    m_size = size;
    m_maxSize = size;
    m_arr = (T*) malloc(sizeof(T) * size);
    //cudaMallocManaged(&m_arr, sizeof(T) * size);
    for (size_t i = 0; i < size; ++i) {
      m_arr[i] = val;
    }
  }

  const T& operator[](size_t ind) const
  {
    return m_arr[ind];
  }

  T& operator[](size_t ind)
  {
    return m_arr[ind];
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

};





