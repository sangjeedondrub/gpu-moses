/*
 * Array.h
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */

#pragma once

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

protected:
  size_t m_size, m_maxSize;
  T *m_arr;

};

