/*
 * Array.h
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */

#pragma once
#include <cuda.h>

template<typename T>
class Array
{
public:
  __device__
  Array(size_t size, const T &val = T())
  {
    m_size = size;
    m_maxSize = size;

    m_arr = (T*) malloc(sizeof(T) * size);
  }

  __device__
  ~Array()
  {
    free(m_arr);
  }

  __device__
  size_t size() const
  { return m_size; }

  __device__
  const T& operator[](size_t ind) const
  { return m_arr[ind]; }

  __device__
  T& operator[](size_t ind)
  { return m_arr[ind]; }

  __device__
  const T* getArray() const
  { return m_arr; }

  __device__
  void resize(size_t newSize)
  {
    //std::cerr << "newSize=" << newSize << std::endl;
    if (newSize > m_maxSize) {
      T *newArr = (T*) malloc(sizeof(T) * newSize);

      size_t oldSize = m_size;
      memcpy(newArr, m_arr, sizeof(T) * oldSize);

      free(m_arr);
      m_arr = newArr;

      m_maxSize = newSize;
    }

    m_size = newSize;
  }

  __device__
  void push_back(const T &v)
  {
    if (m_size >= m_maxSize) {
      resize(m_size + 1);
    }

    m_arr[m_size- 1] = v;
  }

  __host__
  const T Get(size_t ind) const
  {
    T ret;
    cudaMemcpy(&ret, &m_arr[ind], sizeof(T), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    return ret;
  }

  __device__
  int Compare (const Array<T> &other) const
  {
    // -1 = less than
    // +1 = more than
    // 0  = same

    size_t thisSize = size()
       ,otherSize = other.size();

    if (thisSize != otherSize) {
      return (thisSize < otherSize) ? -1 : 1;
    }

    for (size_t i = 0; i < thisSize; ++i) {
      bool thisVal = m_arr[i];
      bool otherVal = other[i];
      if (thisVal != otherVal) {
        return thisVal ? 1 : -1;
      }
    }

    return 0;
  }

  __device__
  bool operator< (const Array<T> &compare) const {
    return Compare(compare) < 0;
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

};
