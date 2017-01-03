#pragma once
#include <string>

class EncoderDecoder
{
public:
  void Load(const std::string &path);

protected:
  std::string path_;
};
