/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "../CUDA/Managed.h"

class Manager;

class FeatureFunction : public Managed
{
public:
  size_t classId;
  size_t startInd;
  size_t numScores;

  virtual ~FeatureFunction()
  {}

  virtual void Load()
  {}

  enum ClassId
  {
    Distortion = 123,
    WordPenalty = 567,
    PhraseDictionaryMemory = 6,
  };

protected:

};
