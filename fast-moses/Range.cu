#include <sstream>
#include "Range.h"

__host__
std::string Range::Debug() const
{
  std::stringstream strm;
  strm << "[" << startPos << "," << endPos << "]";
  return strm.str();
}

