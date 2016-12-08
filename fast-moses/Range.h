#pragma once

class Range
{
public:
  explicit Range()
  {}

  inline Range(size_t startPos, size_t endPos) :
      m_startPos(startPos), m_endPos(endPos)
  {
  }

  __device__
  inline size_t GetStartPos() const
  {
    return m_startPos;
  }

  __device__
  inline size_t GetEndPos() const
  {
    return m_endPos;
  }

  inline void SetStartPos(size_t val)
  {
    m_startPos = val;
  }
  inline void SetEndPos(size_t val)
  {
    m_endPos = val;
  }

protected:
  // m_endPos is inclusive
  size_t m_startPos, m_endPos;

};
