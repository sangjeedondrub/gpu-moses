/*
 * WordsBitmap.h
 *
 *  Created on: Oct 6, 2013
 *      Author: hieuhoang
 */
#pragma once

#include <unistd.h>
#include <vector>

namespace FastMoses
{
class WordsRange;
class System;
  
class WordsBitmap
{
protected:
  std::vector<bool>  m_bitmap;

public:
  WordsBitmap(); // do not implement
  WordsBitmap(const WordsBitmap &copy); // do not implement

  // creating the inital hypo. No words translated
  WordsBitmap(size_t size);
  WordsBitmap(const WordsBitmap &copy, const WordsRange &range);
  virtual ~WordsBitmap();

  size_t GetSize() const
  { return m_bitmap.size(); }

  bool GetValue(size_t pos) const
  { return m_bitmap[pos]; }

  //! count of words translated
  size_t GetNumWordsCovered() const;

  //! count of words translated
  size_t GetFirstGapPos() const;

  bool IsComplete() const {
    return GetSize() == GetNumWordsCovered();
  }

  bool WithinReorderingConstraint(const WordsRange &prevRange, const WordsRange &nextRange, const System &system) const;

  //! whether the wordrange overlaps with any translated word in this bitmap
  bool Overlap(const WordsRange &compare) const;

  std::string Debug() const;
};

}
