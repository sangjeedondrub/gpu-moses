/*
 * TargetPhrase.cpp
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "TargetPhrase.h"
#include "Util.h"
#include "System.h"
#include "FF/TranslationModel/PhraseTable.h"

using namespace std;

namespace FastMoses
{

TargetPhrase::TargetPhrase(size_t size, size_t numScores)
  :Phrase(size)
  ,m_scores(numScores)
{
  // TODO Auto-generated constructor stub

}

TargetPhrase::~TargetPhrase()
{
}

TargetPhrase *TargetPhrase::CreateFromString(
  const FeatureFunction &ff,
  const std::string &targetStr,
  const std::string &scoreStr,
  bool logScores,
  const System &system)
{
  vector<string> toks;

  // words
  Tokenize(toks, targetStr);
  TargetPhrase *phrase = new TargetPhrase(toks.size(), system.GetTotalNumScores());

  for (size_t i = 0; i < toks.size(); ++i) {
    Word &word = phrase->GetWord(i);
    word.CreateFromString(toks[i]);
  }

  // score
  phrase->GetScores().CreateFromString(ff, scoreStr, logScores, system);

  return phrase;
}

void TargetPhrase::CreateMemory(void *&mem, size_t &memSize, const PhraseTable &pt) const
{
	//cerr << "creating mem for " << Debug() << endl;

	size_t numScores = pt.GetNumScores();
	size_t size = GetSize();
	size_t memNeeded = sizeof(UINT32) // num of words
					+ size * sizeof(UINT32) // words
					+ numScores * sizeof(SCORE);
	size_t memUsed = 0;

	void *ptMem = malloc(memNeeded);

	// write num words
	UINT32 *ptMemUINT32 = (UINT32*) ptMem;
	ptMemUINT32[0] = GetSize();
	memUsed += sizeof(UINT32);

	// write words
	for (size_t i = 0; i < size; ++i) {
		const Word &word = GetWord(i);
		VOCABID vocabId = word.GetVocab();
		ptMemUINT32[i+1] = (UINT32) vocabId;
		memUsed += sizeof(UINT32);
	}

	// write scores
	size_t startInd = pt.GetStartInd();

	SCORE *ptMemSCORE = (SCORE*) (ptMem + memUsed);
	for (size_t i = 0; i < numScores; ++i) {
		ptMemSCORE[i] = m_scores.GetScore(startInd + i);

		memUsed += sizeof(SCORE);
	}

	// done writing to mem
	assert(memNeeded == memUsed);

	size_t newSize = memSize + memNeeded;
	void *newMem = realloc(mem, newSize);
	void *memDest = newMem + memSize;
	memcpy(memDest, ptMem, memNeeded);

	memSize = newSize;
	mem = newMem;

	free(ptMem);
}

std::string TargetPhrase::Debug() const
{
  stringstream strme;
  strme << Phrase::Debug() << " ";
  strme << m_scores.Debug();
  return strme.str();
}

}

