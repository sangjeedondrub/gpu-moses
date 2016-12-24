#pragma once

const size_t MAX_STACK_SIZE = 100;

class Stack
{
	Hypothesis m_hypos[MAX_STACK_SIZE*2];
	size_t m_numHypos;
public:
  	__device__ Stack()
  	:m_numHypos(0)
	{
	}
	
	__device__ void AddHypo(const Hypothesis &hypo)
	{
		m_hypos[m_numHypos] = hypo;
		++m_numHypos;
	}
	
	__device__ size_t GetNumHypos() const
	{ return m_numHypos; }
	
	__device__ const Hypothesis &GetHypo(size_t i) const
	{ return m_hypos[i]; }
	
};
