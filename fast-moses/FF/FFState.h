#pragma once

namespace FastMoses {

class FFState
{
public:
  virtual ~FFState()
  {}
  virtual size_t GetHash() const  = 0;
  virtual bool operator==(const FFState &other) const = 0;

};

}

