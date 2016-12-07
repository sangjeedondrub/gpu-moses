#include <iostream>
#include "Manager.h"
#include "Phrase.h"
#include "Hypothesis.h"
#include "PhraseTableMemory.h"

using namespace std;

Manager::Manager(const std::string &inputStr, const PhraseTableMemory &pt)
:m_pt(pt)
{
  m_input = Phrase::CreateFromString(inputStr);
  cerr << "m_input=" << m_input->Debug() << endl;

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

void Manager::Process()
{
  char *str;
  cudaMallocHost(&str, 10000);

  checkManager<<<1,1>>>(str, *this);
  cudaDeviceSynchronize();
  cerr << "mgr=" << str << endl;

  size_t inputSize = m_input->GetSize();
  cerr << "inputSize=" << inputSize << endl;
  m_tpsArr.Resize(inputSize * inputSize, NULL);

  cerr << "before:" << DebugTPSArr() << endl;
  Lookup<<<inputSize, inputSize>>>(*this);
  cudaDeviceSynchronize();
  cerr << "after:" << DebugTPSArr() << endl;

  /*
  m_stacks.Init(*this, m_input->GetSize() + 1);

  Hypothesis *hypo = new Hypothesis();
  Stack &stack = m_stacks[0];
  */
}

std::string Manager::DebugTPSArr() const
{
  std::stringstream strm;
  for (size_t i = 0; i < m_tpsArr.GetSize(); ++i) {
    strm << m_tpsArr[i] << " ";
  }
  return strm.str();
}
