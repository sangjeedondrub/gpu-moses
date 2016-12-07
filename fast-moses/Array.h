/*
 * Array.h
 *
 *  Created on: 29 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <thrust/pair.h>
#include <iostream>
#include <sstream>
#include <string>
#include <cuda.h>
#include "CUDA/Managed.h"

template<typename T, typename Compare = thrust::less<T> >
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
    //std::cerr << "newSize=" << newSize << std::endl;
    if (newSize > GetMaxSize()) {
      T *temp;
      cudaMallocManaged(&temp, sizeof(T) * newSize);
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

  __host__
  std::string Debug() const
  {
    std::stringstream strm;
    size_t size = GetSize();
    strm << size << ":";
    for (size_t i = 0; i < size; ++i) {
      strm << Get(i) << " ";
    }

    return strm.str();
  }

  __host__ __device__
  thrust::pair<bool, size_t> UpperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> ret;
    //std::cerr << "sought=" << sought << std::endl;
    //std::cerr << "m_size=" << m_size << std::endl;
    for (size_t i = 0; i < m_size; ++i) {
      const T &currEle = m_arr[i];
      //std::cerr << i << "=" << currEle << std::endl;

      if (Compare()(currEle, sought)) {
        // carry on, do nothing
        //std::cerr << "HH1" << std::endl;
      }
      else if (Compare()(sought, currEle)) {
        // overshot without finding sought
        //std::cerr << "HH2" << std::endl;
        ret.first = false;
        ret.second = i;
        return ret;
      }
      else {
        // =
        //std::cerr << "HH3" << std::endl;
        ret.first = true;
        ret.second = i;
        return ret;
      }
    }

    // sought is not in array
    ret.first = false;
    ret.second = m_size;
    return ret;
  }

  __host__
  void Insert(size_t ind, const T &val)
  {
    Resize(GetSize() + 1);
    //std::cerr << "HH5" << GetSize() << std::endl;
    Shift(ind, 1);
    //std::cerr << "HH6" << std::endl;

    m_arr[ind] = val;
    //std::cerr << "HH7" << std::endl;
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

  __host__
  void Shift(int start, int offset)
  {
    for (int destInd = m_size - 1; destInd >= start; --destInd) {
      int sourceInd = destInd - offset;
      if (sourceInd < start) {
        return;
      }
      //std::cerr << sourceInd << "->" << destInd << " " << m_arr <<  std::endl;
      m_arr[destInd] = m_arr[sourceInd];
    }
  }

};


////////////////////////////////////////////////////////

template<typename T, typename Compare = thrust::less<T> >
class Set2 : public Managed
{
public:

  // assumes there's nothing there. Otherwise it will be a multiset
  __host__
  void Insert(const T &val)
  {
    thrust::pair<bool, size_t> pair;
    pair = m_arr.UpperBound(val);
    assert(!pair.first);
    size_t ind = pair.second;
    //std::cerr << "ind=" << ind << std::endl;

    m_arr.Insert(ind, val);
  }

  __host__
  std::string Debug() const
  {
    return m_arr.Debug();
  }

protected:
  Array<T> m_arr;

};

