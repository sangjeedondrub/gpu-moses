#include "Bitmap.h"
#include "Range.h"

__device__
Bitmap::Bitmap(size_t size)
:m_size(size)
{
  m_bitmap = (bool*) malloc(sizeof(bool) * size);
}

__device__
Bitmap::~Bitmap()
{
  free(m_bitmap);
}

__device__
void Bitmap::Init()
{
  for (size_t i = 0; i < m_size; ++i) {
    m_bitmap[i] = false;
  }

  m_numWordsCovered = 0;
}

  __device__
void Bitmap::Init(const Bitmap &copy, const Range &range)
{
  for (size_t i = 0; i < m_size; ++i) {
    m_bitmap[i] = copy.m_bitmap[i];
  }

  m_numWordsCovered = copy.m_numWordsCovered;

  SetValueNonOverlap(range);
}

  __device__
void Bitmap::SetValueNonOverlap(Range const& range) {
  size_t startPos = range.GetStartPos();
  size_t endPos = range.GetEndPos();

  for(size_t pos = startPos; pos <= endPos; pos++) {
    m_bitmap[pos] = true;
  }

  m_numWordsCovered += range.GetNumWordsCovered();

}

