#pragma once
#include <thrust/device_vector.h>

class InputPath;
class Phrase;
class Manager;

class InputPaths
{
public:
  typedef thrust::device_vector<InputPath*> Coll;

  void Init(const Phrase &input, const Manager &mgr);

  const InputPath &GetBlank() const
  {  return *m_blank; }

protected:
  InputPath *m_blank;

  Coll m_inputPaths;

};
