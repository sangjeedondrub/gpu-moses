/*
 * Vector.h
 *
 *  Created on: 7 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "Managed.h"

template<typename T>
class Vector : public Managed
{
public:
  Vector()
  :m_arr(NULL)
  {}

  virtual ~Vector()
  {}

  __device__
  void resize(size_t newSize)
  {
    free(m_arr);
  }

protected:
  T *m_arr;
  size_t m_size, m_maxSize;

};

