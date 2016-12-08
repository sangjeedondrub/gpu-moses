#pragma once
#include "Bitmap.h"
#include "ScoresUnmanaged.h"

class Manager;
class TargetPhrase;
class Bitmap;
class Range;

class Hypothesis
{
public:

  __device__
  Hypothesis(const Manager &mgr);

  __device__
  void Init(const Manager &mgr);

  __device__
  void Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp, const Range &range);

  __device__
  const Bitmap &GetBitmap() const
  { return m_bitmap; }

protected:
  const Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;
  Bitmap m_bitmap;
  const Hypothesis *m_prevHypo;
  ScoresUnmanaged m_scores;

};
