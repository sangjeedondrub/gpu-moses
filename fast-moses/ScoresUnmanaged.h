/*
 * ScoresUnmanaged.h
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "CUDA/Array.h"
#include "TypeDef.h"
#include "Scores.h"

class ScoresUnmanaged : public Array<SCORE>
{
public:
  __device__
  ScoresUnmanaged(size_t size, const SCORE &val = 0)
  :Array(size, val)
  {}

  __device__
  void PlusEqual(const ScoresUnmanaged &other);

  __device__
  void PlusEqual(const Scores &other);

protected:
};



