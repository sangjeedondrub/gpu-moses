#pragma once

#include "CUDA/Managed.h"

class Manager;
class TargetPhrase;

class Hypothesis : public Managed
{
public:
  void Init(Manager &mgr);
  void Init(Manager &mgr, const TargetPhrase &tp);

protected:
  Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;

};
