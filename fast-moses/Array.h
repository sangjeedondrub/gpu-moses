/*
 * Array.h
 *
 *  Created on: 29 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <iostream>
#include <sstream>
#include <string>
#include <cuda.h>
#include "CUDA/Managed.h"

template<typename T>
class Array : public Managed
{
public:
  __host__ Array(size_t size = 0)
  {
    m_size = size;
    m_maxSize = size;

    if (size) {
      //m_arr = (T*) malloc(sizeof(T) * size);
      cudaMallocManaged(&m_arr, sizeof(T) * size);
    }
    else {
      m_arr = NULL;
    }
  }

  ~Array()
  {
    cudaFree(m_arr);
  }

  __device__ size_t size() const
  { return m_size; }

  __host__ size_t GetSize() const
  {
    return m_size;
    /*
    size_t ret;
    cudaMemcpy(&ret, &m_size, sizeof(size_t), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    return ret;
    */
  }

  __host__ void SetSize(size_t val)
  {
    m_size = val;
    /*
    cudaMemcpy(&m_size, &val, sizeof(size_t), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    */
  }

  __host__ size_t GetMaxSize() const
  {
    return m_maxSize;
    /*
    size_t ret;
    cudaMemcpy(&ret, &m_maxSize, sizeof(size_t), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    return ret;
    */
  }

  __host__ void SetMaxSize(size_t val)
  {
    m_maxSize = val;
    /*
    cudaMemcpy(&m_maxSize, &val, sizeof(size_t), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    */
  }

  __device__ const T& operator[](size_t ind) const
  { return m_arr[ind]; }

  __host__ __device__ T& operator[](size_t ind)
  { return m_arr[ind]; }

  __host__ const T Get(size_t ind) const
  {
    return m_arr[ind];
    /*
    T ret;
    cudaMemcpy(&ret, &m_arr[ind], sizeof(T), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    return ret;
    */
  }

  __host__ void Set(size_t ind, const T &val)
  {
    //m_arr[ind] = val;

    cudaMemcpy(&m_arr[ind], &val, sizeof(T), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();

  }

  __host__ void Resize(size_t newSize)
  {
    if (newSize > GetMaxSize()) {
      T *temp;
      cudaMalloc(&temp, sizeof(T) * newSize);
      cudaDeviceSynchronize();

      size_t currSize = GetSize();
      cudaMemcpy(temp, m_arr, sizeof(T) * currSize, cudaMemcpyDeviceToDevice);
      cudaDeviceSynchronize();

      cudaFree(m_arr);
      cudaDeviceSynchronize();

      m_arr = temp;

      SetMaxSize(newSize);
    }

     SetSize(newSize);
  }

  __host__ void push_back(const T &v)
  {
    size_t currSize = GetSize();
    size_t maxSize = GetMaxSize();

    if (currSize >= maxSize) {
      Resize(1 + maxSize * 2);
    }

    Set(currSize, v);
    SetSize(currSize + 1);
  }

  __host__ std::string Debug() const
  {
    std::stringstream strm;
    size_t size = GetSize();
    strm << size << ":";
    for (size_t i = 0; i < size; ++i) {
      strm << Get(i) << " ";
    }

    return strm.str();
  }

  __device__ bool upperBound(const T &sought, size_t &ind)
  {
    for (size_t i = 0; i < m_size; ++i) {
      const T &currEle = m_arr[i];
      if (sought == currEle) {
        ind = i;
        return true;
      }
      else if (sought > currEle) {
        ind = i;
        return false;
      }
    }

    ind = m_size;
    return false;
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

};


////////////////////////////////////////////////////////

template<typename T>
class Set2 : public Managed
{
public:

protected:
  Array<T> m_arr;

};

