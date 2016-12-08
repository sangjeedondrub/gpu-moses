#pragma once

#include "CUDA/Managed.h"

class Manager;
class TargetPhrase;

class Hypothesis : public Managed
{
public:
  void Init(const Manager &mgr);
  void Init(const Manager &mgr, const TargetPhrase &tp);

protected:
  const Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;

};
