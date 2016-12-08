#pragma once

class Manager;
class TargetPhrase;

class Hypothesis
{
public:

  __device__
  Hypothesis() {}

  void Init(const Manager &mgr);
  void Init(const Manager &mgr, const TargetPhrase &tp);

protected:
  const Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;

};
