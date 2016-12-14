#include "Bitmap.h"
#include "Range.h"

__device__
Bitmap::Bitmap(size_t size)
:m_bitmap(size)
{
}

__device__
Bitmap::~Bitmap()
{
}

__device__
void Bitmap::Init()
{
  for (size_t i = 0; i < m_bitmap.size(); ++i) {
    m_bitmap[i] = false;
  }

  m_numWordsCovered = 0;
}

  __device__
void Bitmap::Init(const Bitmap &copy, const Range &range)
{
  for (size_t i = 0; i < m_bitmap.size(); ++i) {
    m_bitmap[i] = copy.m_bitmap[i];
  }

  m_numWordsCovered = copy.m_numWordsCovered;

  SetValueNonOverlap(range);
}

  __device__
void Bitmap::SetValueNonOverlap(Range const& range) {
  size_t startPos = range.startPos;
  size_t endPos = range.endPos;

  for(size_t pos = startPos; pos <= endPos; pos++) {
    m_bitmap[pos] = true;
  }

  m_numWordsCovered += range.GetNumWordsCovered();

}

__device__
int Bitmap::Compare (const Bitmap &compare) const {
  // -1 = less than
  // +1 = more than
  // 0  = same

  size_t thisSize = GetSize()
     ,compareSize = compare.GetSize();

  if (thisSize != compareSize) {
    return (thisSize < compareSize) ? -1 : 1;
  }

  for (size_t i = 0; i < thisSize; ++i) {
    bool thisVal = m_bitmap[i];
    bool otherVal = compare.m_bitmap[i];
    if (thisVal != otherVal) {
      return thisVal ? 1 : -1;
    }
  }

  return 0;
}
