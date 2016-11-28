#pragma once

class Manager;
class TargetPhrase;

class Hypothesis
{
public:
  void Init(Manager &mgr, const TargetPhrase &tp);

protected:
  Manager *m_mgr;
  const TargetPhrase *m_targetPhrase;

};
