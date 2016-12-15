/*
 * WordPenalty.h
 *
 *  Created on: 15 Dec 2016
 *      Author: hieu
 */

#pragma once
#include "FeatureFunction.h"

class WordPenalty : public FeatureFunction
{
public:
  WordPenalty();
  virtual ~WordPenalty();
};

