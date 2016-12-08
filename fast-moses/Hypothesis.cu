#include "Hypothesis.h"
#include "Bitmap.h"
#include "Phrase.h"
#include "Manager.h"

  __device__
void Hypothesis::Init(const Manager &mgr)
{
  m_mgr = &mgr;

  const Phrase &input = mgr.GetInput();
  size_t inputSize = input.size();
  m_bitmap = new Bitmap(inputSize);
  m_bitmap->Init();
}


  __device__
void Hypothesis::Init(const Manager &mgr, const TargetPhrase &tp)
{
	m_mgr = &mgr;
	m_targetPhrase = &tp;

  const Phrase &input = mgr.GetInput();
  size_t inputSize = input.size();
  m_bitmap = new Bitmap(inputSize);
  m_bitmap->Init();
}

