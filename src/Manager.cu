#include <iostream>
#include "Manager.h"
#include "Phrase.h"
#include "Hypothesis.h"
#include "Stack.h"
#include "Range.h"
#include "System.h"
#include "MyVocab.h"
#include "FF/FeatureFunctions.h"
#include "TranslationModel/PhraseTableMemory.h"

using namespace std;

Manager::Manager(const System &sys, const std::string &inputStr)
:system(sys)
,m_tpsVec(0)
,initPhrase(sys, 0)
{
  m_input = Phrase::CreateFromString(inputStr);
  //cerr << "m_input=" << m_input->Debug() << endl;

}

Manager::~Manager()
{
  delete m_input;
}

__global__ void checkManager(char *str, const Manager &mgr)
{
  const Phrase &input = mgr.GetInput();
  checkPhrase<<<1,1>>>(str, input);

}


///////////////////////////////////////
__global__
void Lookup(Manager &mgr)
{
  int start = blockIdx.x;
  int end = threadIdx.x;

  if (start > end) {
    return;
  }

  const Phrase &input = mgr.GetInput();
  size_t inputSize = input.size();

  const PhraseTableMemory &pt = *mgr.system.featureFunctions.pt;
  const TargetPhrases *tps = pt.Lookup(input, start, end);

  mgr.GetInputPath(start, end).targetPhrases =  tps;
}

__global__
void Process1stStack(const Manager &mgr, Stacks &stacks)
{
  Hypothesis *hypo = new Hypothesis(mgr);
  hypo->Init(mgr);
  Stack &stack = stacks[0];
  stack.add(hypo);
}

__global__
void ProcessStack(size_t stackInd, const Manager &mgr, Stacks &stacks)
{
  int hypoInd = blockIdx.x;
  int start = blockIdx.y;
  int end = blockIdx.z;

  if (start > end) {
    return;
  }

  const InputPath &path = mgr.GetInputPath(start, end);
  const TargetPhrases *tps = path.targetPhrases;
  if (tps == NULL || tps->size() == 0) {
    return;
  }

  const Stack &stack = stacks[stackInd];
  const Vector<Hypothesis*> &vec = stack.GetVec();
  const Hypothesis &prevHypo = *vec[hypoInd];
  const Bitmap &prevBM = prevHypo.bitmap;

  if (prevBM.Overlap(path.range)) {
    return;
  }

  if (mgr.system.options.reordering.max_distortion >= 0) {
    int distortion = mgr.ComputeDistortionDistance(prevHypo.path->range.endPos, start);
    if (distortion > mgr.system.options.reordering.max_distortion) {
      //cerr << " NO" << endl;
      return;
    }
  }

  const size_t hypoFirstGapPos = prevBM.GetFirstGapPos();
  bool isLeftMostEdge = (hypoFirstGapPos == start);
  if (isLeftMostEdge) {
    // any length extension is okay if starting at left-most edge
  }
  else if (mgr.system.options.reordering.max_distortion < 0) {
    // unlimmited distortion
  }
  else {
    int distortion = mgr.ComputeDistortionDistance(end, hypoFirstGapPos);
    if (distortion > mgr.system.options.reordering.max_distortion) {
      //cerr << " NO" << endl;
      return;
    }
  }

  // CAN EXTEND - go thru each tp
  for (size_t i = 0; i < tps->size(); ++i) {
    const TargetPhrase *tp = (*tps)[i];
    assert(tp);

    Hypothesis *hypo = new Hypothesis(mgr);
    hypo->Init(mgr, prevHypo, *tp, path);
    const Bitmap &newBM = hypo->bitmap;
    size_t wordsCovered = newBM.GetNumWordsCovered();

    Stack &destStack = stacks[wordsCovered];

    Lock &lock = destStack.getLock();
    lock.lock();

    destStack.add(hypo);

    lock.unlock();
  }
}

__global__
void PruneStack(const Manager &mgr, Stack &stack)
{
  stack.prune(mgr);
}

__global__
void GetBestHypo(const Manager &mgr, const Stack &lastStack, Vector<VOCABID> &vocabIds)
{
  // find best hypo
  const Hypothesis *bestHypo = NULL;
  SCORE bestScore = -999999;

  const Vector<Hypothesis*> &hypos = lastStack.GetVec();
  for (size_t i = 0; i < hypos.size(); ++i) {
    const Hypothesis *hypo = hypos[i];
    if (hypo->getFutureScore() > bestScore) {
      bestScore = hypo->getFutureScore();
      bestHypo = hypo;
    }
  }

  // copy each word to array
  assert(bestHypo);
  size_t pos = 0;
  while (bestHypo) {
    const TargetPhrase &tp = *bestHypo->targetPhrase;

    for (size_t i = tp.size(); i > 0; --i) {
      VOCABID id = tp[i - 1];
      vocabIds[pos] = id;

      ++pos;
    }

    bestHypo = bestHypo->prevHypo;
  }

  // reverse
  for (size_t i = 0; i < pos/2; ++i) {
    VOCABID tmpId = vocabIds[i];
    vocabIds[i] = vocabIds[pos - i - 1];
    vocabIds[pos - i - 1] = tmpId;
  }
}
///////////////////////////////////////
__host__
void Manager::Process()
{
  cerr << endl;
  /*
  char *str;
  cudaMallocHost(&str, 10000);

  checkManager<<<1,1>>>(str, *this);
  cudaDeviceSynchronize();
  cerr << "mgr=" << str << endl;
  */

  cerr << "mgr.system.options.search.stack_size=" << system.options.search.stack_size << endl;

  size_t inputSize = m_input->GetSize();
  cerr << "inputSize=" << inputSize << endl;
  InitInputPaths();

  Lookup<<<inputSize, inputSize>>>(*this);
  cudaDeviceSynchronize();
  cerr << "tps=" << DebugTPSArr() << endl;

  m_stacks.Init(*this, m_input->GetSize() + 1);

  Process1stStack<<<1,1>>>(*this, m_stacks);
  cudaDeviceSynchronize();

  Stack &stack = m_stacks.Get(0);
  cerr << "1st stack=" << stack.GetSize() << endl;

  for (size_t stackInd = 0; stackInd < inputSize; ++stackInd) {
    //cerr << "HH0:" << stackInd << endl;
    Stack &stack = m_stacks.Get(stackInd);
    //cerr << "HH1:" << stack.debugStr << endl;

    PruneStack<<<1,1>>>(*this, stack);
    cudaDeviceSynchronize();

    size_t stackSize = stack.GetSize();
    //cerr << "HH2:" << stackSize << endl;

    //ProcessStack<<<1,1>>>(stackInd, *this, m_stacks);
    //ProcessStack<<<stackSize, 1>>>(stackInd, *this, m_stacks);
    //ProcessStack<<<1, inputSize>>>(stackInd, *this, m_stacks); // deadlock with lock
    //ProcessStack<<<stackSize, inputSize>>>(stackInd, *this, m_stacks);

    dim3 blocks(stackSize, inputSize, inputSize);
    ProcessStack<<<blocks, 1>>>(stackInd, *this, m_stacks);
    //cerr << "HH3" << endl;

    cudaDeviceSynchronize();
    //cerr << "HH4" << endl;
    m_stacks.PrintStacks();
    //cerr << "stack" << stackInd << "=" << stack.Debug() << endl;
    //cerr << "HH6" << endl;
 }

  //cerr << m_stacks.Back().Debug() << endl;

  // output
  Vector<VOCABID> *bestHypo = new Vector<VOCABID>(100, NOT_FOUND_DEVICE);
  GetBestHypo<<<1,1>>>(*this, m_stacks.Back(), *bestHypo);
  cudaDeviceSynchronize();

  cerr << "Best Translation: ";
  for (size_t i = 0; i < bestHypo->size(); ++i) {
    VOCABID id = (*bestHypo)[i];
    if (id == NOT_FOUND_DEVICE) {
      break;
    }
    //cerr << "id=" << id << " ";
    cerr << FastMoses::MyVocab::Instance().GetString(id) << " ";
  }
  cerr << endl;

  delete(bestHypo);
}

std::string Manager::DebugTPSArr() const
{
  std::stringstream strm;
  for (size_t i = 0; i < m_tpsVec.size(); ++i) {
    const InputPath &path = m_tpsVec[i];
    const TargetPhrases *tps = path.targetPhrases;
    strm << path.range.Debug() << " ";
    strm << tps;
    if (tps) {
      strm << "(" << tps->GetSize() << ")";
    }
    strm << " " << endl;
  }
  return strm.str();
}

__global__
void InitPathRange(Manager &mgr)
{
  int start = blockIdx.x;
  int end = threadIdx.x;

  if (start > end) {
    return;
  }

  InputPath &path = mgr.GetInputPath(start, end);
  path.range.startPos = start;
  path.range.endPos = end;
}

__host__
void Manager::InitInputPaths()
{
  size_t inputSize = m_input->GetSize();
  m_tpsVec.Resize(inputSize * inputSize);

  InitPathRange<<<inputSize, inputSize>>>(*this);
  cudaDeviceSynchronize();
}

__device__
size_t Manager::RangeToInd(int start, int end) const
{
  const Phrase &input = GetInput();
  size_t inputSize = input.size();

  size_t ret = start * inputSize + end;
  return ret;
}

__device__
InputPath &Manager::GetInputPath(int start, int end)
{
  InputPath &path = m_tpsVec[RangeToInd(start, end)];
  return path;
}

__device__
const InputPath &Manager::GetInputPath(int start, int end) const
{
  const InputPath &path = m_tpsVec[RangeToInd(start, end)];
  return path;
}

__device__
int Manager::ComputeDistortionDistance(size_t prevEndPos,
    size_t currStartPos) const
{
  int dist = 0;
  if (prevEndPos == NOT_FOUND_DEVICE) {
    dist = currStartPos;
  }
  else {
    dist = (int)prevEndPos - (int)currStartPos + 1;
  }
  return abs(dist);
}
