#include <iostream>
#include "Manager.h"
#include "Phrase.h"
#include "Hypothesis.h"
#include "PhraseTableMemory.h"
#include "Stack.h"
#include "Range.h"

using namespace std;

Manager::Manager(const std::string &inputStr, const PhraseTableMemory &pt)
:m_pt(pt)
,m_tpsVec(true, 0)
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

__device__
const TargetPhrases *Manager::GetTargetPhrases(int start, int end) const
{
  const Phrase &input = GetInput();
  size_t inputSize = input.size();
  const TargetPhrases *tps = m_tpsVec[start * inputSize + end];
  return tps;
}

__device__
void Manager::SetTargetPhrases(int start, int end, const TargetPhrases *tps)
{
  const Phrase &input = GetInput();
  size_t inputSize = input.size();
  m_tpsVec[start * inputSize + end] = tps;
}

///////////////////////////////////////
__global__ void Lookup(Manager &mgr)
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

  mgr.SetTargetPhrases(start, end, tps);
}

__global__ void Process1stStack(const Manager &mgr, Stacks &stacks)
{
  Hypothesis *hypo = new Hypothesis(mgr);
  hypo->Init(mgr);
  Stack &stack = stacks[0];
  stack.Add(hypo);
}

__global__ void ProcessStack(size_t stackInd, const Manager &mgr, Stacks &stacks)
{
  int hypoInd = blockIdx.x;
  int start = blockIdx.y;
  int end = blockIdx.z;

  if (start > end) {
    return;
  }

  const Range range(start, end);

  const TargetPhrases *tps = mgr.GetTargetPhrases(start, end);
  if (tps == NULL || tps->size() == 0) {
    return;
  }

  const Stack &stack = stacks[stackInd];

  const Set<Hypothesis*> &set = stack.GetSet();
  const Vector<Hypothesis*> &vec = set.GetVec();
  const Hypothesis &prevHypo = *vec[hypoInd];
  const Bitmap &prevBM = prevHypo.GetBitmap();

  if (prevBM.Overlap(range)) {
    return;
  }

  for (size_t i = 0; i < tps->size(); ++i) {
    const TargetPhrase *tp = (*tps)[i];
    assert(tp);

    Hypothesis *hypo = new Hypothesis(mgr);
    hypo->Init(mgr, prevHypo, *tp, range);
    const Bitmap &newBM = hypo->GetBitmap();
    size_t wordsCovered = newBM.GetNumWordsCovered();

    Stack &destStack = stacks[wordsCovered];

    Lock &lock = destStack.GetLock();
    lock.lock();

    destStack.Add(hypo);

    lock.unlock();
  }
}

///////////////////////////////////////

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
  m_tpsVec.Resize(inputSize * inputSize, NULL);

  Lookup<<<inputSize, inputSize>>>(*this);
  cudaDeviceSynchronize();
  cerr << "tps=" << DebugTPSArr() << endl;

  m_stacks.Init(*this, m_input->GetSize() + 1);

  Process1stStack<<<1,1>>>(*this, m_stacks);
  cudaDeviceSynchronize();

  Stack &stack = m_stacks[0];
  cerr << "1st stack=" << stack.GetSize() << endl;

  for (size_t stackInd = 0; stackInd < inputSize; ++stackInd) {
    const Stack &stack = m_stacks[stackInd];
    size_t stackSize = stack.GetSize();

    //ProcessStack<<<1,1>>>(stackInd, *this, m_stacks);
    //ProcessStack<<<stackSize, 1>>>(stackInd, *this, m_stacks);
    //ProcessStack<<<1, inputSize>>>(stackInd, *this, m_stacks); // deadlock with lock
    //ProcessStack<<<stackSize, inputSize>>>(stackInd, *this, m_stacks);

    dim3 blocks(stackSize, inputSize, inputSize);
    ProcessStack<<<blocks, 1>>>(stackInd, *this, m_stacks);

    cudaDeviceSynchronize();
    m_stacks.PrintStacks();
  }
}

std::string Manager::DebugTPSArr() const
{
  std::stringstream strm;
  for (size_t i = 0; i < m_tpsVec.GetSize(); ++i) {
    const TargetPhrases *tps = m_tpsVec[i];
    strm << tps;
    if (tps) {
      strm << "(" << tps->GetSize() << ")";
    }
    strm << " ";
  }
  return strm.str();
}
