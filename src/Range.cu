#include <sstream>
#include "Range.h"
#include "CUDA/Util.h"

__host__
std::string Range::Debug() const
{
  std::stringstream strm;
  strm << "[" << startPos << "," << endPos << "]";
  return strm.str();
}

__device__
void Range::Debug(char *out) const
{
  StrCat(out, "[");
  StrCat(out, itoaDevice(startPos));
  StrCat(out, ",");
  StrCat(out, itoaDevice(endPos));
  StrCat(out, "]");

}
