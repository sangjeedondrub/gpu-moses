#pragma once

//#include "Debug.cuh"

class WordsRangeDev
{
public:
	UINT32 startPos, endPos;

	__device__ WordsRangeDev()
	{}
	
	__device__ WordsRangeDev(UINT32 s, UINT32 e)
	:startPos(s)
	,endPos(e)
	{
	}
	
	__device__ int GetNumWordsCovered() const
	{ return endPos - startPos + 1; };

	__device__ int Distortion(const WordsRangeDev &prevRange) const
	{
		int ret = startPos - prevRange.endPos - 1;
	}

	/*
	__device__ void Debug() const
	{
		DebugStr("[");
		DebugStr(startPos);
		DebugStr("-");
		DebugStr(endPos);
		DebugStr("]");
	}
	*/
};
