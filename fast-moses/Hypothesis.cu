#include "Hypothesis.h"
#include "Bitmap.h"
#include "Phrase.h"
#include "Manager.h"

  __device__
void Hypothesis::Init(const Manager &mgr)
{
  m_mgr = &mgr;
  m_prevHypo = NULL;
  m_targetPhrase = NULL;

  const Phrase &input = mgr.GetInput();
  size_t inputSize = input.size();
  m_bitmap = new Bitmap(inputSize);
  m_bitmap->Init();
}


  __device__
void Hypothesis::Init(const Manager &mgr, const Hypothesis &prevHypo, const TargetPhrase &tp)
{
	m_mgr = &mgr;
	m_prevHypo = &prevHypo;
	m_targetPhrase = &tp;

  const Phrase &input = mgr.GetInput();
  size_t inputSize = input.size();
  m_bitmap = new Bitmap(inputSize);
  m_bitmap->Init();
}

