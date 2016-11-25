#pragma once
//
//  SquareMatrix.h
//  small-moses
//
//  Created by Hieu Hoang on 18/01/2014.
//  Copyright (c) 2014 Hieu Hoang. All rights reserved.
//
#include <iostream>

namespace FastMoses
{
class WordsRange;
class WordsBitmap;
  
class SquareMatrix
{
  friend std::ostream& operator<<(std::ostream &out, const SquareMatrix &matrix);
protected:
  const size_t m_size; /**< length of the square (sentence length) */
  float *m_array; /**< two-dimensional array to store floats */
  
  SquareMatrix(); // not implemented
  SquareMatrix(const SquareMatrix &copy); // not implemented
  
public:
  SquareMatrix(size_t size);
  ~SquareMatrix() {
    free(m_array);
  }
  /** Returns length of the square: typically the sentence length */
  inline size_t GetSize() const {
    return m_size;
  }
  /** Get a future cost score for a span */
  inline float GetScore(size_t startPos, size_t endPos) const {
    return m_array[startPos * m_size + endPos];
  }
  /** Set a future cost score for a span */
  void SetScore(const WordsRange &range, float value);

  inline void SetScore(size_t startPos, size_t endPos, float value) {
    m_array[startPos * m_size + endPos] = value;
  }

  float GetScore(const WordsBitmap &bitmap) const;
  
};


}

