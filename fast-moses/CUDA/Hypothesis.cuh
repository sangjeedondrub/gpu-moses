#pragma once

#include "ScoresDev.cuh"
#include "Debug.cuh"

class Hypothesis
{
	const Hypothesis *m_prevHypo;
	const TargetPhraseDev *m_targetPhrase;
	WordsRangeDev m_currSourceRange;
	WordsBitmapDev m_bitmap;
	bool m_isValid;
	
	ScoresDev m_scores;
	
public:
	// to initalise mem pool
	__device__ Hypothesis()
	{
	}
	
	// for 1 empty hypo	
	__device__ Hypothesis(size_t inputSize, const TargetPhraseDev &tp)
	:m_bitmap(inputSize)
	,m_prevHypo(NULL)
	,m_targetPhrase(&tp)
	,m_isValid(true)
	{
	}
	
	__device__ ~Hypothesis()
	{
	}

	__device__ void SetHypo(const Hypothesis &prevHypo, 
							const TargetPhraseDev &tp, 
							const WordsRangeDev &range)
	{
		const WordsBitmapDev &prevBitmap = prevHypo.GetBitmap();
		m_isValid = prevBitmap.IsValid(range);

		DebugStr((int) this);
		DebugStr(" ");
		prevBitmap.Debug();
		DebugStr(" ");

		//range.Debug();
		DebugStr(range.startPos);
		DebugStr("-");
		DebugStr(range.endPos);

		DebugStr(" ");
		DebugBoolToStr(m_isValid);
		DebugStr(" ");

		if (m_isValid) {
			m_prevHypo = &prevHypo;
			m_targetPhrase = &tp;
			m_currSourceRange = range;

			m_bitmap.Set(prevBitmap);
			m_bitmap.Set(m_currSourceRange);

			m_bitmap.Debug();
		}

		DebugStr("\n");
	}

	__device__ bool IsValid() const
	{ return m_isValid; }

	__device__ const WordsBitmapDev &GetBitmap() const
	{ return m_bitmap; }

	__device__ const WordsRangeDev &GetSourceRange() const
	{ return m_currSourceRange; }
	
	__device__ bool WithinDistortionLimit() const
	{
		const WordsRangeDev &prevRange = m_prevHypo->GetSourceRange();
		int distortion = m_currSourceRange.Distortion(prevRange);
		bool ret = (distortion < 7); // TODO
		return ret;
	}
	
	__device__ void CalcIsValid()
	{
		if (!m_isValid) {
			return;
		}
		
		m_isValid = WithinDistortionLimit(); 
		if (!m_isValid) {
			return;
		}
	}
	
	__device__ void CalcPhrasePenalty(SCORE *weights)
	{
		UINT32 scoreInd = 4; // TODO
		m_scores.Add(weights, 1, scoreInd);
	}

	__device__ void CalcWordPenalty(SCORE *weights)
	{
		UINT32 scoreInd = 5; // TODO
		UINT32 numWords = m_targetPhrase->GetSize();
		m_scores.Add(weights, numWords, scoreInd);	
	}
	
	__device__ void Process(UINT32 numScores, SCORE *weights)
	{
		CalcIsValid();
		if (!m_isValid) {
			return;
		}
		
		m_scores.SetNumScores(numScores);
		
		CalcPhrasePenalty(weights);
		CalcPhrasePenalty(weights);
	}
};
