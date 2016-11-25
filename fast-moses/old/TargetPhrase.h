/*
 * TargetPhrase.h
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#pragma once

#include "Phrase.h"
#include "Scores.h"

namespace FastMoses
{
class PhraseTable;

class TargetPhrase: public Phrase
{
public:
  static TargetPhrase *CreateFromString(const FeatureFunction &ff,
                                        const std::string &targetStr,
                                        const std::string &scoreStr,
                                        bool logScores,
                                        const System &system);

  TargetPhrase(size_t size, size_t numScores);

  TargetPhrase(const TargetPhrase &copy); // do not implement

  virtual ~TargetPhrase();

  Scores &GetScores() {
    return m_scores;
  }
  const Scores &GetScores() const {
    return m_scores;
  }

  void SetFutureScore(SCORE futureScore) {
    m_futureScore = futureScore;
  }
  SCORE GetFutureScore() const {
    return m_futureScore;
  }

  virtual std::string Debug() const;

  void CreateMemory(void *&mem, size_t &memSize, const PhraseTable &pt) const;
protected:
  Scores m_scores;
  SCORE m_futureScore;
};

}

