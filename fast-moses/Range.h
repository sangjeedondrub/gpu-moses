#pragma once
#include <string>

class Range
{
public:
  explicit Range(); // don't implement

  __device__
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

  //! count of words translated
  __device__
  inline size_t GetNumWordsCovered() const
  {
    return m_endPos - m_startPos + 1;
  }

  __host__
  std::string Debug() const;


protected:
  // m_endPos is inclusive
  size_t m_startPos, m_endPos;

};
