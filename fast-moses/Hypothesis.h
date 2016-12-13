#pragma once
#include "Bitmap.h"
#include "ScoresUnmanaged.h"

class Manager;
class TargetPhrase;
class Bitmap;
class Range;
class InputPath;

class Hypothesis
{
public:
  const Manager *mgr;
  const InputPath *path;
  const TargetPhrase *targetPhrase;
  Bitmap bitmap;
  const Hypothesis *prevHypo;

  ScoresUnmanaged scores;
  char *stateData;

  SCORE sss;

  __device__
  Hypothesis(const Manager &mgr);

  __device__
  void Init(const Manager &mgr);

  __device__
  void Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp, const InputPath &path);

  __host__
  SCORE GetFutureScore() const;
  
protected:

};

__global__
void getTotalScore(const Hypothesis &hypo, SCORE &output);

