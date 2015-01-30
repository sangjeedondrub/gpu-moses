#pragma once

#include "Util.cuh"
#include "TypeDef.cuh"

__device__ void DebugStr(char *dest)
{
	AppendStr(debugStr, debugStrSize, dest);
}

__device__ void DebugStr(int val)
{
	char str[111];
	itoa(val, str, 10);
	AppendStr(debugStr, debugStrSize, str);
}

__device__ void DebugBoolToStr(bool val)
{
	if (val) {
		DebugStr("1");
	}
	else {
		DebugStr("0");
	}
}

__device__ void DebugFloatToStr(float val)
{
	char str[111];
	dtoa(str, val);
	AppendStr(debugStr, debugStrSize, str);
}

__global__ void DebugScores()
{
	DebugStr(" scores=");
	for (size_t i = 0; i < g_numScoresDev; ++i) {
		char str[111];
		dtoa(str, g_weightsDev[i]);
		AppendStr(debugStr, debugStrSize, str);
		DebugStr(",");
	}
}

__global__ void DebugInputInfo()
{
	DebugStr(" inputInfoHost=");

	char str[111];
	itoa(g_inputInfoDev.inputSize, str, 10);
	AppendStr(debugStr, debugStrSize, str);

}

__global__ void DebugTPS()
{
	char str[111];

	DebugStr(" paths=");
	itoa(g_inputInfoDev.numPaths, str, 10);
	AppendStr(debugStr, debugStrSize, str);

	DebugStr(" ranges=");

	for (size_t i = 0; i < g_inputInfoDev.numPaths; ++i) {
		PathInfo &pathInfo = g_pathInfoDev[i];

		// range
		DebugStr("[");
		DebugStr(pathInfo.range.startPos);
		DebugStr(",");
		DebugStr(pathInfo.range.endPos);
		DebugStr("]=");

		// tps
		DebugStr(pathInfo.numTPS);
		DebugStr(",");
		DebugStr((int) pathInfo.tpsMem);

		// done
		DebugStr("");
	}
	DebugStr("\n");
}

__device__ void DebugCreateTPSDev(size_t pathInd, UINT32 numTPS, void *tpsMem)
{
	DebugStr("path=");

	char str[111];

	DebugStr(pathInd);
	DebugStr(",");
	DebugStr(numTPS);
	DebugStr(",");
	DebugStr((size_t) tpsMem);
	DebugStr(",");

	UINT32 *tpsMemUINT32 = (UINT32*) tpsMem;
	UINT32 numTPSMem = tpsMemUINT32[0];

	DebugStr(numTPSMem);
	DebugStr("\n");
}

__device__ void DebugCreateTPSDev2(size_t tpInd, size_t tpsMem, const TargetPhraseDev &tp)
{
	DebugStr("tp=");

	char str[111];

	// tpInd
	DebugStr(tpInd);
	DebugStr(",");

	// tpsMem
	DebugStr(tpsMem);
	DebugStr(",");

	// tp size
	DebugStr(tp.GetSize());

	// words
	for (size_t i = 0; i < tp.GetSize(); ++i) {
		DebugStr(",");
		DebugStr(tp.GetWord(i));
	}

	// scores
	for (size_t i = 0; i < NUMSCORES; ++i) {
		DebugStr(",");
		DebugFloatToStr(tp.GetScore(i));
	}

	DebugStr("\n");
}

