#include <iostream>
#include "Manager.h"
#include "Phrase.h"
#include "Hypothesis.h"
#include "PhraseTableMemory.h"
#include "Stack.h"

using namespace std;

Manager::Manager(const std::string &inputStr, const PhraseTableMemory &pt)
:m_pt(pt)
,m_tpsArr(true, 0)
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

  Array<const TargetPhrases*> &tpsArr = mgr.GetTargetPhrases();
  tpsArr[start * inputSize + end] = tps;
  //tpsArr[start * inputSize + end] = (const TargetPhrases*) 0x3434;

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
  const Stack &stack = stacks[stackInd];

  int hypoInd = blockIdx.x;
  int start = threadIdx.x;

  const Set<Hypothesis*> &set = stack.GetSet();
  const Array<Hypothesis*> &vec = set.GetVec();
  const Hypothesis &prevHypo = *vec[hypoInd];

  Hypothesis *hypo = new Hypothesis(mgr);
  //hypo->Init(mgr, prevHypo);
  Stack &destStack = stacks[0];
  //destStack.Add(hypo);

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
  m_tpsArr.Resize(inputSize * inputSize, NULL);

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

    ProcessStack<<<stackSize, inputSize>>>(stackInd, *this, m_stacks);
    cudaDeviceSynchronize();
  }
}

std::string Manager::DebugTPSArr() const
{
  std::stringstream strm;
  for (size_t i = 0; i < m_tpsArr.GetSize(); ++i) {
    const TargetPhrases *tps = m_tpsArr[i];
    strm << tps;
    if (tps) {
      strm << "(" << tps->GetSize() << ")";
    }
    strm << " ";
  }
  return strm.str();
}
