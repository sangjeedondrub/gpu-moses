#pragma once
#include <thrust/device_vector.h>
#include "CUDA/Managed.h"

class Range;

class Bitmap : public Managed
{
public:
  typedef thrust::device_vector<bool> Vec;
  explicit Bitmap(size_t size);

  void Init();
  void Init(const Bitmap &copy, const Range &range);

protected:
  Vec m_bitmap;

  void SetValueNonOverlap(Range const& range);

};
