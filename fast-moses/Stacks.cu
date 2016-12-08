#include <iostream>
#include "Stacks.h"
#include "Stack.h"

using namespace std;

void Stacks::Init(const Manager &mgr, size_t numStacks)
{
	m_vec.Resize(numStacks);
	for (size_t i = 0; i < numStacks; ++i) {
		m_vec[i] = new Stack();
	}
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
