#pragma once

#include <vector>
#include <string>
#include "TypeDef.h"

namespace FastMoses {

class FeatureFunction;
class System;
  
class Scores
{
public:
  Scores(size_t numScores);
  Scores(const Scores &copy);
  virtual ~Scores();
  void CreateFromString(const FeatureFunction &ff, const std::string &line, bool logScores, const System &system);

  SCORE GetWeightedScore() const {
    return m_weightedScore;
  }

  void Add(const Scores &other, const System &system);
  void Add(const FeatureFunction &ff, SCORE score, const System &system);
  void Add(const FeatureFunction &ff, const std::vector<SCORE> &scores, const System &system);

#ifdef SCORE_BREAKDOWN
  SCORE GetScore(size_t ind) const
  { return m_scores[ind]; }
#endif

  std::string Debug() const;

protected:
#ifdef SCORE_BREAKDOWN
  std::vector<SCORE> m_scores; // maybe it doesn't need this
#endif
  SCORE m_weightedScore;
};

}
