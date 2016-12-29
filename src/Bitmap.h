#pragma once
#include "Range.h"
#include "CUDA/Array.h"

class Range;

class Bitmap
{
public:
  __device__
  Bitmap(size_t size);

  __device__
  ~Bitmap();

  __device__
  void Init();

  __device__
  void Init(const Bitmap &copy, const Range &range);

  __device__
  size_t GetSize() const {
    return m_bitmap.size();
  }

  //! Count of words translated.
  __device__
  size_t GetNumWordsCovered() const {
    return m_numWordsCovered;
  }

  //! position of 1st word not yet translated, or NOT_FOUND if everything already translated
  __device__
  size_t GetFirstGapPos() const {
    return m_firstGap;
  }

  //! whether every word has been translated
  __device__
  bool IsComplete() const {
    return GetSize() == GetNumWordsCovered();
  }

  //! whether the wordrange overlaps with any translated word in this bitmap
  __device__
  bool Overlap(const Range &compare) const {
    for (size_t pos = compare.startPos; pos <= compare.endPos; pos++) {
      if (m_bitmap[pos])
        return true;
    }
    return false;
  }

  __device__
  int Compare (const Bitmap &other) const;

  __device__
  bool operator< (const Bitmap &other) const {
    return Compare(other) < 0;
  }

  __device__
  void Debug(char *out) const;


protected:
  size_t m_numWordsCovered;
  size_t m_firstGap; //! Cached position of first gap, or NOT_FOUND.

  Array<bool> m_bitmap;

  __device__
  void SetValueNonOverlap(Range const& range);

};
