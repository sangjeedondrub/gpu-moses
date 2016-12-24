#pragma once


class ScoresDev
{
public:
  __device__ ScoresDev()
    :m_weightedScore(0)
#ifdef SCORE_BREAKDOWN
    ,m_scores(NULL)
#endif
  {
  }

  __device__ void SetNumScores(UINT32 numScores)
  {
	#ifdef SCORE_BREAKDOWN
		m_scores = new SCORE[numScores];
		for (size_t i = 0; i < numScores; ++i) {
			m_scores[i] = 0;
		}
	#endif    
  }
  
  __device__ void Add(SCORE *weights, SCORE score, UINT32 scoreInd)
  {
	#ifdef SCORE_BREAKDOWN
	  m_scores[scoreInd] += score;
	#endif
 	m_weightedScore += score * weights[scoreInd];
  }
  
protected:
#ifdef SCORE_BREAKDOWN
  SCORE *m_scores; // maybe it doesn't need this
#endif
  SCORE m_weightedScore;
};



