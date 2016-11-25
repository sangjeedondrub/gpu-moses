#pragma once

#include <cuda.h>
#include <vector>
#include "TypeDef.h"

namespace FastMoses {
  class WordsRange;
};

void InitGPU(const std::vector<SCORE> &weights);
void FinalizeGPU();

void InitInputInfo(size_t inputSize, size_t numPaths);
void CompleteInputInfo();
void SetTargetPhrases(size_t pathInd, void *tpsMemHost, size_t memSize, const FastMoses::WordsRange &range);
void InitStacksHost(size_t inputSize);
void InitStackHost(size_t stackInd);
void ProcessStackHost(size_t stackInd);
void FinalizeStackHost(size_t stackInd);

void DebugStacks(size_t inputSize);



