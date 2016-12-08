/*
 * ScoresUnmanaged.cu
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */
#include "ScoresUnmanaged.h"

__device__
void ScoresUnmanaged::PlusEqual(const ScoresUnmanaged &other)
{
  for (size_t i = 0; i < m_size; ++i) {
    (*this)[i] += other[i];
  }
}

__device__
void ScoresUnmanaged::PlusEqual(const Scores &other)
{
  for (size_t i = 0; i < m_size; ++i) {
    (*this)[i] += other[i];
  }
}



