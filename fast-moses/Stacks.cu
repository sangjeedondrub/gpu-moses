#include <iostream>
#include "Stacks.h"
#include "Stack.h"

using namespace std;

__global__
void InitStacks(Stacks &stacks)
{
  int stackInd = blockIdx.x;
  Stack &stack = stacks[stackInd];

  Array<Hypothesis*> *arr = new Array<Hypothesis*>(5000);
  stack.m_arr = arr;
}

void Stacks::Init(const Manager &mgr, size_t numStacks)
{
	m_vec.Resize(numStacks);
	for (size_t i = 0; i < numStacks; ++i) {
		m_vec[i] = new Stack();
	}
	InitStacks<<<numStacks, 1>>>(*this);
}

void Stacks::PrintStacks() const
{
  cerr << "stacks=";
  for (size_t i = 0; i < m_vec.GetSize(); ++i) {
    Stack *stack = m_vec.Get(i);
    cerr << stack->GetSize() << " ";
  }
  cerr << endl;
}
