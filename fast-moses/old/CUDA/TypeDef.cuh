#pragma once

#include "TypeDef.h"
#include "WordsRangeDev.cuh"

class TargetPhraseDev;
class Stacks;
class Hypothesis;

struct InputInfo
{
	UINT32 inputSize;
	UINT32 numPaths;
};

struct PathInfo
{
	WordsRangeDev range;
	UINT32 numTPS;
	void *tpsMem;
	TargetPhraseDev *tps; // array of tp that points to particular bits of tpsMem
};

//////////////////////////////////////////////////////////

const size_t NUM_NEW_HYPOS = 10000; // TODO
const size_t NUMSCORES = 5; // TODO

#define DEBUG_STR_MAX 1000000
__device__ UINT32 debugStrSize;
__device__ char debugStr[DEBUG_STR_MAX];

__device__ UINT32 g_numScoresDev;
__device__ SCORE *g_weightsDev;

__device__ Stacks *g_stacks;
__device__ Hypothesis *g_hypos;
__device__ InputInfo g_inputInfoDev;
__device__ PathInfo *g_pathInfoDev;
__device__ size_t g_numHypos;
__device__ TargetPhraseDev *g_emptyTP;

InputInfo g_inputInfoHost;
PathInfo *g_pathInfoHost;

__device__ SCORE temp;
