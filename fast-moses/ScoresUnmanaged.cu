/*
 * ScoresUnmanaged.cu
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */
#include "ScoresUnmanaged.h"
#include "FF/FeatureFunction.h"

#include "TypeDef.h"

__device__
ScoresUnmanaged::ScoresUnmanaged(size_t size, const SCORE &val)
:m_total(0)
{
  m_scores = new SCORE[NUM_SCORES];
}

__device__
void ScoresUnmanaged::PlusEqual(const ScoresUnmanaged &other)
{
  for (size_t i = 0; i < NUM_SCORES; ++i) {
    m_scores[i] += other.m_scores[i];
  }
  m_total += other.m_total;
}

__device__
void ScoresUnmanaged::PlusEqual(const Scores &other)
{
  for (size_t i = 0; i < NUM_SCORES; ++i) {
    m_scores[i] += other[i];
  }
  m_total += other.GetTotal();
}

__device__
void ScoresUnmanaged::PlusEqual(const FeatureFunction &ff, SCORE score)
{
  assert(ff.numScores == 1);
  m_scores[ff.startInd] += score;
  m_total += score;
}


