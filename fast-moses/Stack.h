#pragma once
#include "CUDA/Set.h"

class Hypothesis;

class Stack
{
public:
	void Add(Hypothesis *hypo);

protected:
	Set2<Hypothesis*> m_coll;
};
