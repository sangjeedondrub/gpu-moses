/*
 * Array.h
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */

#pragma once
#include <cuda.h>
#include <thrust/pair.h>

template<typename T>
class Array
{
public:
  __device__
  Array(size_t size)
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
  void resize(size_t newSize)
  {
    reserve(newSize);
    m_size = newSize;
  }

  __device__
  void reserve(size_t newSize)
  {
    if (newSize > m_maxSize) {
      T *newArr = (T*) malloc(sizeof(T) * newSize);

      size_t oldSize = m_size;
      memcpy(newArr, m_arr, sizeof(T) * oldSize);

      free(m_arr);
      m_arr = newArr;

      m_maxSize = newSize;
    }
  }

  __device__
  void push_back(const T &v)
  {
    if (m_size >= m_maxSize) {
      reserve(1 + m_maxSize * 2);
    }

    m_arr[m_size] = v;
    ++m_size;
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
      const T &thisVal = m_arr[i];
      const T &otherVal = other[i];
      if (thisVal < otherVal) {
        return +1;
      }
      else if (otherVal < thisVal) {
        return -1;
      }
    }

    return 0;
  }

  __device__
  bool operator< (const Array<T> &compare) const {
    return Compare(compare) < 0;
  }

  template<typename CC>
  __device__
  thrust::pair<bool, size_t> upperBound(const T &sought) const
  {
    thrust::pair<bool, size_t> ret(false, m_size);
    //std::cerr << "sought=" << sought << std::endl;
    //std::cerr << "m_size=" << m_size << std::endl;
    int l = 0;
    int r = m_size - 1;
    int x;

    CC comparer;
    while (r >= l) {
      x = (l + r) / 2;

      const T &obj = m_arr[x];
      if (comparer(sought, obj)) {
        r = x - 1;

        if (x < ret.second) {
          ret.second = x;
        }
      }
      else if (comparer(obj, sought)) {
        l = x + 1;
      }
      else {
        // found
        ret.first = true;
        ret.second = x;
        break;
      }
    }
    //std::cerr << "ret.second=" << ret.second << std::endl;
    return ret;


    /*
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
    */
  }

  __device__
  size_t insert(size_t ind, const T &val)
  {
    if (m_size >= m_maxSize) {
      reserve(1 + m_maxSize * 2);
    }

    resize(m_size + 1);
    //std::cerr << "HH5" << GetSize() << std::endl;
    Shift(ind, 1);
    //std::cerr << "HH6" << std::endl;

    m_arr[ind] = val;
    //std::cerr << "HH7" << std::endl;
    return ind;
  }

  __device__
  void Clear()
  {
    m_size = 0;
  }

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

  __device__
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

