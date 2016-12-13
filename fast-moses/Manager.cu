#include <iostream>
#include "Manager.h"
#include "Phrase.h"
#include "Hypothesis.h"
#include "PhraseTableMemory.h"
#include "Stack.h"
#include "Range.h"

using namespace std;

Manager::Manager(const System &sys, const std::string &inputStr, const PhraseTableMemory &pt)
:system(sys)
,m_pt(pt)
,m_tpsVec(true, 0)
,initPhrase(0)
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

  const PhraseTableMemory &pt = mgr.GetPhraseTable();
  const TargetPhrases *tps = pt.Lookup(input, start, end);

  mgr.GetInputPath(start, end).targetPhrases =  tps;
}

__global__
void Process1stStack(const Manager &mgr, Stacks &stacks)
{
  Hypothesis *hypo = new Hypothesis(mgr);
  hypo->Init(mgr);
  Stack &stack = stacks[0];
  stack.Add(hypo);
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
  Hypothesis** vec = stack.GetArr();
  const Hypothesis &prevHypo = *vec[hypoInd];
  const Bitmap &prevBM = prevHypo.bitmap;

  if (prevBM.Overlap(path.range)) {
    return;
  }

  for (size_t i = 0; i < tps->size(); ++i) {
    const TargetPhrase *tp = (*tps)[i];
    assert(tp);

    Hypothesis *hypo = new Hypothesis(mgr);
    hypo->Init(mgr, prevHypo, *tp, path);
    const Bitmap &newBM = hypo->bitmap;
    size_t wordsCovered = newBM.GetNumWordsCovered();

    Stack &destStack = stacks[wordsCovered];

    Lock &lock = destStack.GetLock();
    lock.lock();

    destStack.Add(hypo);

    lock.unlock();
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
    const Stack &stack = m_stacks.Get(stackInd);
    size_t stackSize = stack.GetSize();

    //ProcessStack<<<1,1>>>(stackInd, *this, m_stacks);
    //ProcessStack<<<stackSize, 1>>>(stackInd, *this, m_stacks);
    //ProcessStack<<<1, inputSize>>>(stackInd, *this, m_stacks); // deadlock with lock
    //ProcessStack<<<stackSize, inputSize>>>(stackInd, *this, m_stacks);

    dim3 blocks(stackSize, inputSize, inputSize);
    ProcessStack<<<blocks, 1>>>(stackInd, *this, m_stacks);

    cudaDeviceSynchronize();
    m_stacks.PrintStacks();
    //cerr << "stack=" << stack.Debug() << endl;
  }

  //cerr << "back=" << m_stacks.Back().Debug() << endl;

}

std::string Manager::DebugTPSArr() const
{
  std::stringstream strm;
  for (size_t i = 0; i < m_tpsVec.GetSize(); ++i) {
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
  path.range = Range(start, end);
}

__host__
void Manager::InitInputPaths()
{
  size_t inputSize = m_input->GetSize();
  m_tpsVec.Resize(inputSize * inputSize);

  InitPathRange<<<inputSize, inputSize>>>(*this);

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
