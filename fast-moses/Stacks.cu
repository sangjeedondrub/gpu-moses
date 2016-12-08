#include "Stacks.h"
#include "Stack.h"

void Stacks::Init(const Manager &mgr, size_t numStacks)
{
	m_vec.Resize(numStacks);
	for (size_t i = 0; i < numStacks; ++i) {
		m_vec[i] = new Stack();
	}
}
