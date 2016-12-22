#pragma once
#include "Bitmap.h"
#include "ScoresUnmanaged.h"
#include "CUDA/Array.h"

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
  Array<char> stateData;

  SCORE sss;

  __device__
  Hypothesis(const Manager &mgr);

  __device__
  void Init(const Manager &mgr);

  __device__
  void Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp, const InputPath &path);

  /** check, if two hypothesis can be recombined.
      this is actually a sorting function that allows us to
      keep an ordered list of hypotheses. This makes recombination
      much quicker.
  */
  __device__
  int RecombineCompare(const Hypothesis &other) const;


  __device__
  SCORE getFutureScore() const;

  __host__
  SCORE GetFutureScore() const;

  __host__
  std::string Debug() const;

  __device__
  void Debug(char *out) const;

  /** curr - pos is relative from CURRENT hypothesis's starting index
   * (ie, start of sentence would be some negative number, which is
   * not allowed- USE WITH CAUTION) */
  __device__
  VOCABID GetCurrWord(size_t pos) const;

  /** recursive - pos is relative from start of sentence */
  __device__
  VOCABID GetWord(size_t pos) const;

  __device__
  inline const Range &GetCurrTargetWordsRange() const
  {
    return m_currTargetWordsRange;
  }

protected:
  Range m_currTargetWordsRange;

};

////////////////////////////////////////////////////////////////////////////////////////////
/** defines less-than relation on hypotheses.
* The particular order is not important for us, we need just to figure out
* which hypothesis are equal based on:
*   the last n-1 target words are the same
*   and the covers (source words translated) are the same
* Directly using RecombineCompare is unreliable because the Compare methods
* of some states are based on archictecture-dependent pointer comparisons.
* That's why we use the hypothesis IDs instead.
*/
class HypothesisRecombinationOrderer
{
public:
  __device__
  bool operator()(const Hypothesis* hypoA, const Hypothesis* hypoB) const {
    return (hypoA->RecombineCompare(*hypoB) < 0);
  }

};


////////////////////////////////////////////////////////////////////////////////////////////

__global__
void getTotalScore(const Hypothesis &hypo, SCORE &output);

