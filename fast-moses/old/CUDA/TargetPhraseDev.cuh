#pragma once

#include "TypeDef.h"
#include "TypeDef.cuh"

class TargetPhraseDev
{
	void *m_mem;
	UINT32 *m_words;
	SCORE *m_scores;
	UINT32 m_numWords;
	
public:
	__device__ TargetPhraseDev()
	:m_mem(NULL)
	,m_words(NULL)
	,m_scores(NULL)
	{
	}

	__device__ ~TargetPhraseDev()
	{
		delete m_words;
		delete m_scores;
	}
	
	__device__ void SetEmpty()
	{
		m_numWords = 0;
	}

	__device__ void *Initialize(void *mem)
	{
		m_mem = mem;
	
		// words
		UINT32 *memUINT32 = (UINT32*) mem;
		m_numWords = memUINT32[0];

		m_words = (UINT32*) malloc(sizeof(UINT32) * m_numWords);

		for (size_t i = 0; i < m_numWords; ++i) {
			UINT32 vocabId = memUINT32[i + 1];
			m_words[i] = vocabId;
		}

		// scores
		SCORE *memSCORE = (SCORE*) (mem + (1 + m_numWords) * sizeof(UINT32));
		 
		m_scores = (SCORE*) malloc(sizeof(SCORE) * NUMSCORES);
		for (size_t i = 0; i < NUMSCORES; ++i) {
			m_scores[i] = memSCORE[i];
		} 
		
		void *ret = mem
					+ (1 + m_numWords) * sizeof(UINT32)
					+ NUMSCORES * sizeof(SCORE);
		return ret;
	}

	__device__ UINT32 GetSize() const
	{ return m_numWords; }

	__device__ UINT32 GetWord(UINT32 pos) const
	{ return m_words[pos]; }
	
	__device__ SCORE GetScore(size_t ind) const
	{ return m_scores[ind]; }

};

