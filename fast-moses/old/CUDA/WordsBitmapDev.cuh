#pragma once

#include "WordsRangeDev.cuh"
#include "Debug.cuh"

class WordsBitmapDev
{
	bool *m_bitmap;
	int m_size;
	int m_numWordsCovered;


public:
	__device__ WordsBitmapDev()
	:m_bitmap(NULL)
	{
	}
	
	// for empty hypo
	__device__ WordsBitmapDev(size_t inputSize)
	{
	  m_size = inputSize;
	  m_numWordsCovered = 0;

	  m_bitmap = (bool*) malloc(sizeof(bool) * m_size);
	  for (size_t pos = 0 ; pos < m_size ; pos++) {
	    m_bitmap[pos] = false;
	  }
	}

	__device__ WordsBitmapDev(const WordsBitmapDev &copy)
	{
		Set(copy);
	}

	__device__ ~WordsBitmapDev()
	{
		delete m_bitmap;
	}

	__device__ void Set(const WordsBitmapDev &copy)
	{
		  m_size = copy.m_size;
		  m_numWordsCovered = copy.m_numWordsCovered;

		  m_bitmap = (bool*) malloc(sizeof(bool) * m_size);
		  for (size_t pos = 0 ; pos < m_size ; pos++) {
			m_bitmap[pos] = copy.m_bitmap[pos];
		  }
	}

	__device__ void Set(const WordsRangeDev &range)
	{
		for (size_t i = range.startPos; i <= range.endPos; ++i) {
			m_bitmap[i] = true;
		}

		m_numWordsCovered += range.GetNumWordsCovered();
	}
	
	__device__ bool IsValid(const WordsRangeDev &range) const
	{
		for (size_t i = range.startPos; i <= range.endPos; ++i) {
			if (m_bitmap[i]) {
				return false;
			}
		}

		return true;
	}

	__device__ int GetNumWordsCovered() const
	{ return m_numWordsCovered; };

	__device__ void Debug() const
	{
		for (size_t i = 0; i < m_size; ++i) {
			DebugBoolToStr(m_bitmap[i]);
		}
	}
};

