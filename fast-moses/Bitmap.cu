#include "Bitmap.h"
#include "Range.h"

Bitmap::Bitmap(size_t size)
:m_bitmap(size)
{

}

void Bitmap::Init()
{
  for (size_t i = 0; i < m_bitmap.size(); ++i) {
	m_bitmap[i] = false;
  }
}

void Bitmap::Init(const Bitmap &copy, const Range &range)
{
  for (size_t i = 0; i < m_bitmap.size(); ++i) {
	m_bitmap[i] = copy.m_bitmap[i];
  }
  SetValueNonOverlap(range);
}

void Bitmap::SetValueNonOverlap(Range const& range) {
  size_t startPos = range.GetStartPos();
  size_t endPos = range.GetEndPos();

  for(size_t pos = startPos; pos <= endPos; pos++) {
    m_bitmap[pos] = true;
  }
}

