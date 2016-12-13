#include <sstream>
#include "Range.h"

__host__
std::string Range::Debug() const
{
  std::stringstream strm;
  strm << "[" << m_startPos << "," << m_endPos << "]";
  return strm.str();
}

