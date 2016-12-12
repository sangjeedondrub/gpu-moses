/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */

#include "FeatureFunctions.h"
#include "Distortion.h"

FeatureFunctions::FeatureFunctions()
{
  totalSize = 0;

  sfff = new Distortion();
  totalSize += sfff->stateSize;
  sfff->startOffset = 0;


}
