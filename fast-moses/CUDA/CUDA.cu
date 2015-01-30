#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cuda.h>
#include "TypeDef.h"
#include "WordsRange.h"
#include "CUDA.cuh"
#include "TargetPhraseDev.cuh"
#include "WordsRangeDev.cuh"
#include "WordsBitmapDev.cuh"
#include "Hypothesis.cuh"
#include "Stack.cuh"
#include "Stacks.cuh"
#include "Debug.cuh"
#include "TypeDef.cuh"

using namespace std;

template<typename T>
class Set
{
protected:
	size_t m_maxSize, m_size;
	T *m_array;
public:
	__device__ Set(size_t maxSize)
	{ 
	  m_maxSize = maxSize;
	  m_size = 0;
	  m_array = new T[maxSize];
	}

	__device__ ~Set()
	{
		delete m_array;
	}
	
	__device__ bool Add(const T &obj)
	{
		if (m_size >= m_maxSize) {
			return false;
		}
		
		m_array[m_size] = obj;
		++m_size;
		return true;
	}
};

///////////////////////////////////////////////////////////
__global__ void InitGPU()
{
	debugStrSize = 0;
	
	char *strSource = "Sample string";
	AppendStr(debugStr, debugStrSize, strSource);

	g_emptyTP = new TargetPhraseDev();
	g_emptyTP->SetEmpty();
}

void InitGPU(const std::vector<SCORE> &weights)
{	

	InitGPU<<<1, 1>>>();

	UINT32 numScores = weights.size();

 	CALL_CUDA(cudaMemcpyToSymbol(g_numScoresDev, &numScores, sizeof(UINT32), 0, cudaMemcpyHostToDevice));

	SCORE *weightDevArr;
	CALL_CUDA(cudaMalloc((SCORE**)&weightDevArr, sizeof(SCORE) * numScores));
 	CALL_CUDA(cudaMemcpyToSymbol(g_weightsDev, &weightDevArr, sizeof(SCORE*), 0, cudaMemcpyHostToDevice));

	SCORE weightHost[numScores];
	std::copy(weights.begin(), weights.end(), weightHost);
 	CALL_CUDA(cudaMemcpy(weightDevArr, &weightHost, sizeof(SCORE) * numScores, cudaMemcpyHostToDevice));

 	DebugScores<<<1,1>>>();
}

void FinalizeGPU()
{
	cerr << "Shutting down" << endl;

	UINT32 debugStrSizeHost;
 	CALL_CUDA(cudaMemcpyFromSymbol(&debugStrSizeHost, debugStrSize, sizeof(UINT32), 0, cudaMemcpyDeviceToHost));
	cerr << "debugStrSizeHost=" << debugStrSizeHost << endl;

	char debugStrHost[DEBUG_STR_MAX];
 	CALL_CUDA(cudaMemcpyFromSymbol(&debugStrHost, debugStr, debugStrSizeHost, 0, cudaMemcpyDeviceToHost));
	cerr << "debugStrHost=" << debugStrHost << endl;

	UINT32 numScoresHost;
 	CALL_CUDA(cudaMemcpyFromSymbol(&numScoresHost, g_numScoresDev, sizeof(UINT32), 0, cudaMemcpyDeviceToHost));
	cerr << "numScoresHost=" << numScoresHost << endl;

	SCORE tempHost;
 	CALL_CUDA(cudaMemcpyFromSymbol(&tempHost, temp, sizeof(SCORE), 0, cudaMemcpyDeviceToHost));
	cerr << "tempHost=" << tempHost << endl;
	
}

void InitInputInfo(size_t inputSize, size_t numPaths)
{	
	g_inputInfoHost.inputSize = inputSize;
	g_inputInfoHost.numPaths = numPaths;

 	CALL_CUDA(cudaMemcpyToSymbol(g_inputInfoDev, &g_inputInfoHost, sizeof(g_inputInfoHost), 0, cudaMemcpyHostToDevice));

 	g_pathInfoHost = (PathInfo*) malloc(sizeof(PathInfo) * numPaths);

	DebugInputInfo<<<1,1>>>();
}

void SetTargetPhrases(size_t pathInd, void *tpsMemHost, size_t memSize, const FastMoses::WordsRange &range)
{
	PathInfo &pathInfo = g_pathInfoHost[pathInd];
	pathInfo.range.startPos = range.startPos;
	pathInfo.range.endPos = range.endPos;
	
	void *tpsMemDev = NULL;
	if (tpsMemHost) {
	
		UINT32 *tpsMemHostUINT32 = (UINT32*) tpsMemHost;
		UINT32 numTPS = tpsMemHostUINT32[0];
		pathInfo.numTPS = numTPS;
		
		// target phrases to device		
		CALL_CUDA(cudaMalloc((void**)&tpsMemDev, memSize));	
	  	CALL_CUDA(cudaMemcpy(tpsMemDev, tpsMemHost, memSize, cudaMemcpyHostToDevice));
	}
	else {
		pathInfo.numTPS = 0;
	}
	
	pathInfo.tpsMem = tpsMemDev;	
}

__global__ void CreateTPSDev()
{
	// initialise tps
	UINT32 numPaths = g_inputInfoDev.numPaths;
	char str[111];
	itoa(numPaths, str, 10);

	DebugStr(" numPaths=");
	DebugStr(str);
	DebugStr("\n");

	for (size_t pathInd = 0; pathInd < numPaths; ++pathInd) {
  		PathInfo &path = g_pathInfoDev[pathInd];
  		UINT32 numTPS = path.numTPS;
  		void *tpsMem = path.tpsMem;
		DebugCreateTPSDev(pathInd, numTPS, tpsMem);

		size_t tempMem = (size_t) tpsMem;
		tempMem += sizeof(UINT32);
		tpsMem = (void*) tempMem;

		//numTPS = 1;
  		path.tps = (TargetPhraseDev*) malloc(sizeof(TargetPhraseDev) * numTPS);
		for (size_t tpInd = 0; tpInd < numTPS; ++tpInd) {
			TargetPhraseDev &tp = path.tps[tpInd];

			/*
			AppendStr(debugStr, debugStrSize, " tpsMem=");
			itoa((int)tpsMem, str, 10);
			AppendStr(debugStr, debugStrSize, str);
			AppendStr(debugStr, debugStrSize, " ");
			*/
			tpsMem = tp.Initialize(tpsMem);
			/*
			itoa((int)tpsMem, str, 10);
			AppendStr(debugStr, debugStrSize, str);
			AppendStr(debugStr, debugStrSize, " ");

			DebugCreateTPSDev2(tpInd, (size_t) tpsMem, tp);
			*/
		}

  	}
}

void CompleteInputInfo()
{
	UINT32 numPaths = g_inputInfoHost.numPaths;
	size_t memSize = sizeof(PathInfo) * numPaths;
	 
	PathInfo *pathInfoDevArr;
	CALL_CUDA(cudaMalloc((PathInfo**)&pathInfoDevArr, memSize));
 	CALL_CUDA(cudaMemcpyToSymbol(g_pathInfoDev, &pathInfoDevArr, sizeof(PathInfo*), 0, cudaMemcpyHostToDevice));

 	CALL_CUDA(cudaMemcpy(pathInfoDevArr, g_pathInfoHost, memSize, cudaMemcpyHostToDevice));

 	DebugTPS<<<1,1>>>();

 	CreateTPSDev<<<1,1>>>();

}

__global__ void InitStacks(size_t inputSize)
{
	g_stacks = new Stacks(inputSize);
	
	Stack &firstStack = g_stacks->GetStack(0);
	
	Hypothesis emptyHypo(inputSize, *g_emptyTP);
	firstStack.AddHypo(emptyHypo);

  	// init todo hypos 
	g_hypos = new Hypothesis[NUM_NEW_HYPOS];

	DebugStr("NUM_NEW_HYPOS=");
	DebugStr(NUM_NEW_HYPOS);
	DebugStr(" ");
	DebugStr(inputSize);
	DebugStr(" ");
	DebugStr((int) g_hypos);
	DebugStr("\n");
}

void InitStacksHost(size_t inputSize)
{
	InitStacks<<<1, 1>>>(inputSize);
}

__global__ void InitStack(size_t stackInd)
{
  int row = blockIdx.x * blockDim.x + threadIdx.x;
  if (row > 0) {
  	return;
  }
  
  DebugStr("g_hypos=");
  DebugStr((int) g_hypos);
  DebugStr("\n");

  // create all potential new hypos in hypos array
  UINT32 numPaths = g_inputInfoDev.numPaths;

  Stack &stack = g_stacks->GetStack(stackInd);
  
  g_numHypos = 0;
  for (size_t prevHypoInd = 0; prevHypoInd < stack.GetNumHypos(); ++prevHypoInd) {
  	const Hypothesis &prevHypo = stack.GetHypo(prevHypoInd);
    	
  	for (size_t pathInd = 0; pathInd < numPaths; ++pathInd) {
  		PathInfo &path = g_pathInfoDev[pathInd];
  		const WordsRangeDev &range = path.range;
  		void *tpsMem = path.tpsMem;
  		
  		if (tpsMem) {
			UINT32 *tpsUINT32 = (UINT32*) tpsMem;
			UINT32 numTPS = tpsUINT32[0];
			
	  		for (size_t tpInd = 0; tpInd < numTPS; ++tpInd) {
	  			const TargetPhraseDev &tp = path.tps[tpInd];
	  			
		  		Hypothesis &newHypo = g_hypos[g_numHypos];
		  		newHypo.SetHypo(prevHypo, tp, range);


		  		DebugStr((int) &newHypo);
		  		DebugStr("=");
		  		DebugBoolToStr(newHypo.IsValid());
		  		DebugStr("\n");

		  	  	++g_numHypos;
		  	}
	  	}
  	}
  }

	char str[111];

	DebugStr(" g_numHypos=");
	itoa(g_numHypos, str, 10);
	AppendStr(debugStr, debugStrSize, str);
}

void InitStackHost(size_t stackInd)
{
	InitStack<<<4, 1>>>(stackInd);
}

__device__ void ProcessHypo(size_t hypoInd)
{
	Hypothesis &hypo = g_hypos[hypoInd];
	hypo.Process(g_numScoresDev, g_weightsDev);

	//Set<int> s(3);
	//s.Add(4);
	//S s(3);
	
}

__global__ void ProcessStackParallel(size_t stackInd)
{
	int row = blockIdx.x * blockDim.x + threadIdx.x;
	if (row >= g_numHypos) {
		return;
	}
	
	ProcessHypo(row);
}

__global__ void ProcessStackSerial(size_t stackInd)
{
	for (size_t i = 0; i < g_numHypos; ++i) {
		ProcessHypo(i);
	}
}

void ProcessStackHost(size_t stackInd)
{
	//ProcessStackParallel<<<4, 999>>>(stackInd);
	ProcessStackSerial<<<1, 999>>>(stackInd);
}

__global__ void FinalizeStack(size_t stackInd)
{
	size_t numAdded = 0;
	for (size_t i = 0; i < g_numHypos; ++i) {
		Hypothesis &hypo = g_hypos[i];

		DebugStr("hello");
		DebugStr((int) &hypo);
		DebugBoolToStr(hypo.IsValid());
		DebugStr(hypo.GetBitmap().GetNumWordsCovered());

		if (hypo.IsValid()) {
			DebugStr("goodbye");
			const WordsBitmapDev &bm = hypo.GetBitmap();
			int numWordsCovered = bm.GetNumWordsCovered();
			Stack &destStack = g_stacks->GetStack(numWordsCovered);
			destStack.AddHypo(hypo);

			++numAdded;
		}
	}

	char str[111];

	DebugStr(" numAdded=");
	itoa(numAdded, str, 10);
	AppendStr(debugStr, debugStrSize, str);

}

void FinalizeStackHost(size_t stackInd)
{
	FinalizeStack<<<1,1>>>(stackInd);
}

__global__ void DebugStacksDev(size_t inputSize)
{
	char str[111];

	DebugStr("Stacks=");

	for (size_t i = 0; i <= inputSize; ++i) {
		Stack &stack = g_stacks->GetStack(i);
		size_t numHypos = stack.GetNumHypos();

		itoa(numHypos, str, 10);
		AppendStr(debugStr, debugStrSize, str);
		DebugStr(" ");
	}

	DebugStr("\n");

}


void DebugStacks(size_t inputSize)
{
	DebugStacksDev<<<1,1>>>(inputSize);
	
}


