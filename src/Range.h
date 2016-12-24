#pragma once
#include <string>
#include "TypeDef.h"

class Range
{
public:
  size_t startPos, endPos;

  __device__
  explicit Range()
  {}

  __device__
  inline Range(size_t s, size_t e) :
      startPos(s), endPos(e)
  {
  }

  //! count of words translated
  __device__
  inline size_t GetNumWordsCovered() const
  {
    return (startPos == NOT_FOUND_DEVICE) ? 0 : endPos - startPos + 1;
  }

  __host__
  std::string Debug() const;

  __device__
  void Debug(char *out) const;

protected:
  // m_endPos is inclusive

};
