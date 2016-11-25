//
//  SquareMatrix.cpp
//  small-moses
//
//  Created by Hieu Hoang on 18/01/2014.
//  Copyright (c) 2014 Hieu Hoang. All rights reserved.
//

#include <algorithm>
#include "SquareMatrix.h"
#include "WordsRange.h"
#include "WordsBitmap.h"

using namespace std;

namespace FastMoses
{
SquareMatrix::SquareMatrix(size_t size)
:m_size(size)
{
  m_array = (float*) malloc(sizeof(float) * size * size);

  for(size_t row=0; row<size; row++) {
    for(size_t col=row; col<size; col++) {
      SetScore(row, col, -numeric_limits<float>::infinity());
    }
  }
}

void SquareMatrix::SetScore(const WordsRange &range, float value) {
  m_array[range.startPos * m_size + range.endPos] = value;
}

float SquareMatrix::GetScore(const WordsBitmap &bitmap) const
{
  const size_t notInGap= numeric_limits<size_t>::max();
  size_t startGap = notInGap;
  float futureScore = 0.0f;
  for(size_t currPos = 0 ; currPos < bitmap.GetSize() ; currPos++) {
    // start of a new gap?
    if(bitmap.GetValue(currPos) == false && startGap == notInGap) {
      startGap = currPos;
    }
    // end of a gap?
    else if(bitmap.GetValue(currPos) == true && startGap != notInGap) {
      futureScore += GetScore(startGap, currPos - 1);
      startGap = notInGap;
    }
  }
  // coverage ending with gap?
  if (startGap != notInGap) {
    futureScore += GetScore(startGap, bitmap.GetSize() - 1);
  }
  
  return futureScore;
}

}


