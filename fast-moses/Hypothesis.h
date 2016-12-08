#pragma once
#include "Bitmap.h"

class Manager;
class TargetPhrase;
class Bitmap;

class Hypothesis
{
public:

  __device__
  Hypothesis(const Manager &mgr);

  __device__
  void Init(const Manager &mgr);

  __device__
  void Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp);

protected:
  const Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;
  Bitmap m_bitmap;
  const Hypothesis *m_prevHypo;

};
