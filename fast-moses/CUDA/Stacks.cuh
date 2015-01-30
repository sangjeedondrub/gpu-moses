#pragma once

class Stacks
{
	Stack *m_stacks;
public:
	__device__ Stacks(size_t inputSize)
	{
		m_stacks = new Stack[inputSize];
	}

	__device__ ~Stacks()
	{
		delete m_stacks;
	}
	
	__device__ Stack &GetStack(size_t ind)
	{ return m_stacks[ind]; }
};
