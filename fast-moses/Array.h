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
  __device__ Array(size_t size)
  {
    m_size = size;
    m_maxSize = size;
    m_arr = (T*) malloc(sizeof(T) * size);
  }

  size_t size() const
  {
    return m_size;
  }


  __device__ const T& operator[](size_t ind) const
  {
    return m_arr[ind];
  }

  __device__ T& operator[](size_t ind)
  {
    return m_arr[ind];
  }

  __host__ const T Get(size_t ind) const
  {
    T ret;
    cudaMemcpy(&ret, &m_arr[ind], sizeof(T), cudaMemcpyDeviceToHost);
    return ret;
  }

  __host__ void Set(size_t ind, const T &val)
  {
    cudaMemcpy(&m_arr[ind], &val, sizeof(T), cudaMemcpyHostToDevice);
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

};





