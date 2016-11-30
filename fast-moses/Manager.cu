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
  const PhraseTableMemory &pt = mgr.GetPhraseTable();
  pt.Lookup(input, start, end);


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
  Lookup<<<inputSize, inputSize>>>(*this);

  /*
  m_stacks.Init(*this, m_input->GetSize() + 1);

  Hypothesis *hypo = new Hypothesis();
  Stack &stack = m_stacks[0];
  */
}


