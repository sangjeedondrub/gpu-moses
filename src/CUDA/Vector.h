/*
 * Vector.h
 *
 *  Created on: 29 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <iostream>
#include <thrust/pair.h>
#include <thrust/functional.h>
#include <iostream>
#include <sstream>
#include <string>
#include <cuda.h>
#include <cassert>
#include "Managed.h"

template<typename T>
class Vector : public Managed
{
public:
  __host__
  Vector(size_t size, const T &val = T())
  {
    m_size = size;
    m_maxSize = size;

    if (size) {
      cudaMallocManaged(&m_arr, sizeof(T) * size);
    }
    else {
      m_arr = NULL;
    }
  }

  __host__
  ~Vector()
  {
    cudaFree(m_arr);
  }

  __device__ __host__
  size_t size() const
  { return m_size; }

  __host__ __device__
  T& operator[](size_t ind)
  { return m_arr[ind]; }

  __host__ __device__
  const T& operator[](size_t ind) const
  { return m_arr[ind]; }

  __device__
  void resize(size_t newSize, const T &val = T())
  {
    //std::cerr << "newSize=" << newSize << std::endl;
    if (newSize > m_maxSize) {
      //*status = 45;
      __threadfence();         // ensure store issued before trap
      asm("trap;");
    }

    m_size = newSize;
  }

  __host__
  void Resize(size_t newSize, const T &val = T())
  {
    Reserve(newSize);
    m_size = newSize;
  }

  __host__
  void Reserve(size_t newSize)
  {
    if (newSize > m_maxSize) {
      T *temp;
      cudaMallocManaged(&temp, sizeof(T) * newSize);
      cudaDeviceSynchronize();

      size_t currSize = size();
      cudaMemcpy(temp, m_arr, sizeof(T) * currSize, cudaMemcpyDeviceToDevice);
      cudaDeviceSynchronize();

      cudaFree(m_arr);
      cudaDeviceSynchronize();

      m_arr = temp;

      m_maxSize = newSize;
    }

  }

  __host__
  void PushBack(const T &v)
  {
    if (m_size >= m_maxSize) {
      Resize(1 + m_maxSize * 2);
    }

    m_arr[m_size] = v;
    ++m_size;
  }

  __device__
  void push_back(const T &v)
  {
    if (m_size >= m_maxSize) {
      resize(1 + m_maxSize * 2);
    }

    m_arr[m_size] = v;
    ++m_size;
  }

  __host__
  std::string Debug() const
  {
    std::stringstream strm;
    strm << size() << ":";
    for (size_t i = 0; i < size(); ++i) {
      strm << m_arr[i] << " ";
    }

    return strm.str();
  }

  template<typename CC>
  __device__
  thrust::pair<bool, size_t> upperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> ret;
    //std::cerr << "sought=" << sought << std::endl;
    //std::cerr << "m_size=" << m_size << std::endl;
    for (size_t i = 0; i < m_size; ++i) {
      const T &currEle = m_arr[i];
      //std::cerr << i << "=" << currEle << std::endl;

      if (CC()(currEle, sought)) {
        // carry on, do nothing
        //std::cerr << "HH1" << std::endl;
      }
      else if (CC()(sought, currEle)) {
        // overshot without finding sought
        //std::cerr << "HH2" << std::endl;
        ret.first = false;
        ret.second = i;
        return ret;
      }
      else {
        // found it
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

  template<typename CC>
  __host__
  thrust::pair<bool, size_t> UpperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> ret(false, 0);
    //std::cerr << "sought=" << sought << std::endl;
    //std::cerr << "m_size=" << m_size << std::endl;
    /*
    int l = 0;
    int r = m_size - 1;
    int x;

    CC comparer;
    while (r >= l) {
      x = (l + r) / 2;

      const T &obj = m_arr[x];
      if (comparer(sought, obj)) {
        r = x - 1;
      }
      else if (comparer(obj, sought)) {
        l = x + 1;

        if (ret.second < x) {
          ret.second = x;
        }
      }
      else {
        // found
        ret.first = true;
        ret.second = x;
        break;
      }
    }

    return ret;
    */
    // linear search

    for (size_t i = 0; i < m_size; ++i) {
      const T &currEle = m_arr[i];
      //std::cerr << i << "=" << currEle << std::endl;

      if (CC()(currEle, sought)) {
        // carry on, do nothing
        //std::cerr << "HH1" << std::endl;
      }
      else if (CC()(sought, currEle)) {
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

  __device__
  size_t insert(size_t ind, const T &val)
  {
    resize(m_size + 1);
    //std::cerr << "HH5" << GetSize() << std::endl;
    Shift(ind, 1);
    //std::cerr << "HH6" << std::endl;

    m_arr[ind] = val;
    //std::cerr << "HH7" << std::endl;
    return ind;
  }

  __host__
  size_t Insert(size_t ind, const T &val)
  {
    Resize(size() + 1);
    //std::cerr << "HH5" << GetSize() << std::endl;
    Shift(ind, 1);
    //std::cerr << "HH6" << std::endl;

    m_arr[ind] = val;
    //std::cerr << "HH7" << std::endl;
    return ind;
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

  __host__ __device__
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




