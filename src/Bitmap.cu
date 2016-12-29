#include "Bitmap.h"
#include "Range.h"
#include "CUDA/Util.h"

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
  m_firstGap = 0;
}

  __device__
void Bitmap::Init(const Bitmap &copy, const Range &range)
{
  for (size_t i = 0; i < m_bitmap.size(); ++i) {
    m_bitmap[i] = copy.m_bitmap[i];
  }
  m_numWordsCovered = copy.m_numWordsCovered;
  m_firstGap = copy.m_firstGap;

  SetValueNonOverlap(range);
}

  __device__
void Bitmap::SetValueNonOverlap(Range const& range) {
  size_t startPos = range.startPos;
  size_t endPos = range.endPos;

  bool update1stGap = false;
  for(size_t pos = startPos; pos <= endPos; pos++) {
    m_bitmap[pos] = true;

    if (pos == m_firstGap) {
      update1stGap = true;
    }
  }

  m_numWordsCovered += range.GetNumWordsCovered();

  if (update1stGap) {
    m_firstGap = NOT_FOUND_DEVICE;
    for (size_t pos = range.endPos + 1; pos < m_bitmap.size(); ++pos) {
      bool val = m_bitmap[pos];
      if (!val) {
        m_firstGap = pos;
        break;
      }
    }
  }
}

__device__
int Bitmap::Compare (const Bitmap &other) const {
  return m_bitmap.Compare(other.m_bitmap);
}

__device__
void Bitmap::Debug(char *out) const
{
  for (size_t i = 0; i < m_bitmap.size(); ++i) {
    bool val = m_bitmap[i];
    StrCat(out, val?"1":"0");
  }
}

