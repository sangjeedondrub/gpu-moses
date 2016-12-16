/*
 * ScoresUnmanaged.cu
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */
#include "ScoresUnmanaged.h"
#include "System.h"
#include "Scores.h"
#include "FF/FeatureFunction.h"
#include "CUDA/Util.h"

__device__
ScoresUnmanaged::ScoresUnmanaged(size_t size, const SCORE &val)
:m_total(0)
,m_scores(size)
{
}

__device__
ScoresUnmanaged::~ScoresUnmanaged()
{
}

__device__
void ScoresUnmanaged::PlusEqual(const System &sys, const ScoresUnmanaged &other)
{
  for (size_t i = 0; i < sys.featureFunctions.totalNumScores; ++i) {
    m_scores[i] += other.m_scores[i];
  }
  m_total += other.m_total;
}

__device__
void ScoresUnmanaged::PlusEqual(const System &sys, const Scores &other)
{
  for (size_t i = 0; i < sys.featureFunctions.totalNumScores; ++i) {
    m_scores[i] += other[i];
  }
  m_total += other.GetTotal();
}

__device__
void ScoresUnmanaged::PlusEqual(const System &sys, const FeatureFunction &ff, SCORE score)
{
  assert(ff.numScores == 1);
  m_scores[ff.startInd] += score;
  m_total += score;
}

__device__
void ScoresUnmanaged::Debug(char *out) const
{
  char *str = ftoaDevice(m_total);
  StrCat(out, str);
  StrCat(out, "=");

  for (size_t i = 0; i < m_scores.size(); ++i) {
    char *str = ftoaDevice(m_scores[i]);
    StrCat(out, str);
    StrCat(out, " ");
  }

}

