#pragma once
#include <string>

class Range
{
public:
  size_t startPos, endPos;

  explicit Range(); // don't implement

  __device__
  inline Range(size_t s, size_t e) :
      startPos(s), endPos(e)
  {
  }

  //! count of words translated
  __device__
  inline size_t GetNumWordsCovered() const
  {
    return endPos - startPos + 1;
  }

  __host__
  std::string Debug() const;


protected:
  // m_endPos is inclusive

};
