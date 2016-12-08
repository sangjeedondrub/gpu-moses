#pragma once
#include "Range.h"

class Range;

class Bitmap
{
public:
  __device__
  explicit Bitmap(size_t size);

  __device__
  ~Bitmap();

  __device__
  void Init();

  __device__
  void Init(const Bitmap &copy, const Range &range);

  //! Count of words translated.
  __device__
  size_t GetNumWordsCovered() const {
    return m_numWordsCovered;
  }

  //! whether the wordrange overlaps with any translated word in this bitmap
  __device__
  bool Overlap(const Range &compare) const {
    for (size_t pos = compare.GetStartPos(); pos <= compare.GetEndPos(); pos++) {
      if (m_bitmap[pos])
        return true;
    }
    return false;
  }


protected:
  size_t m_size;
  size_t m_numWordsCovered;

  bool *m_bitmap;

  __device__
  void SetValueNonOverlap(Range const& range);

};
