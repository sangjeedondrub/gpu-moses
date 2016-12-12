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
  ScoresUnmanaged scores;
  char *stateData;

  SCORE sss;

  __device__
  Hypothesis(const Manager &mgr);

  __device__
  void Init(const Manager &mgr);

  __device__
  void Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp, const Range &range);

  __device__
  const Bitmap &GetBitmap() const
  { return m_bitmap; }


  __host__
  SCORE GetFutureScore() const;
  
protected:
  const Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;
  Bitmap m_bitmap;
  const Hypothesis *m_prevHypo;

};

__global__
void getTotalScore(const Hypothesis &hypo, SCORE &output);

