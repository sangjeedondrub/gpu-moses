#include <iostream>
#include "Stacks.h"
#include "Stack.h"

using namespace std;

__host__
Stacks::~Stacks()
{
  for (size_t i = 0; i < m_vec.size(); ++i) {
    delete m_vec[i];
  }

}

void Stacks::Init(const Manager &mgr, size_t numStacks)
{
	m_vec.Resize(numStacks);
	for (size_t i = 0; i < numStacks; ++i) {
		m_vec[i] = new Stack(mgr);
	}
}

void Stacks::PrintStacks() const
{
  cerr << "stacks=";
  for (size_t i = 0; i < m_vec.size(); ++i) {
    Stack *stack = m_vec[i];
    cerr << stack->GetSize() << " ";
  }
  cerr << endl;
}
