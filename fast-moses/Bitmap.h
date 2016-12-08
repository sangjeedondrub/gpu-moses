#pragma once

class Range;

class Bitmap
{
public:
  __device__
  explicit Bitmap(size_t size);

  __device__
  ~Bitmap();

  __device__
  void Init();

  __device__
  void Init(const Bitmap &copy, const Range &range);

protected:
  size_t m_size;
  bool *m_bitmap;

  __device__
  void SetValueNonOverlap(Range const& range);

};
