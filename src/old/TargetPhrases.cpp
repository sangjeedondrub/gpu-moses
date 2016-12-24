/*
 * TargetPhrases.cpp
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */
#include <iostream>
#include <stdlib.h>
#include "TargetPhrases.h"
#include "TargetPhrase.h"
#include "Util.h"

using namespace std;

namespace FastMoses
{

TargetPhrases::TargetPhrases()
{
  // TODO Auto-generated constructor stub

}

TargetPhrases::~TargetPhrases()
{
  RemoveAllInColl(m_coll);
}

void TargetPhrases::CalcFutureScore()
{
  m_futureScore = -numeric_limits<SCORE>::infinity();
  Coll::iterator iter;
  for (iter = m_coll.begin(); iter != m_coll.end(); ++iter) {
    const TargetPhrase &tp = **iter;
    SCORE tpFutureScore = tp.GetFutureScore();
    if (tpFutureScore > m_futureScore) {
      m_futureScore = tpFutureScore;
    }
  }
}

void TargetPhrases::CreateMemory(const PhraseTable &pt)
{
	//cerr << "creating mem for targetphrases " << GetSize() << endl;
	m_memSize = sizeof(UINT32);
	m_mem = malloc(m_memSize);

	UINT32 *memUINT32 = (UINT32*) m_mem;
	memUINT32[0] = GetSize();

	Coll::const_iterator iter;
	for (iter = m_coll.begin(); iter != m_coll.end(); ++iter) {
		const TargetPhrase &tp = **iter;
		tp.CreateMemory(m_mem, m_memSize, pt);
	}
}

void TargetPhrases::WriteMemory() const
{

}

}

