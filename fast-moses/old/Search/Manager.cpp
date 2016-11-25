/*
 * Manager.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */
#include <iostream>
#include "Manager.h"
#include "InputPath.h"
#include "System.h"
#include "Util.h"
#include "System.h"
#include "TargetPhrases.h"
#include "FF/StatefulFeatureFunction.h"
#include "FF/TranslationModel/PhraseTable.h"
#include "CUDA/CUDA.cuh"

using namespace std;

namespace FastMoses
{

Manager::Manager(Sentence &sentence, System &system)
  :m_sentence(sentence)
  ,m_system(system)
  ,m_emptyPhrase(0, system.GetTotalNumScores())
  ,m_emptyRange(NOT_FOUND, NOT_FOUND)
{ 
  system.timer.check("Initialize search with sentence");
  system.Initialize(m_sentence);

  system.timer.check("Begin CreateInputPaths");
  CreateInputPaths();

  system.timer.check("Begin Lookup");
  Lookup();

  system.timer.check("Begin WriteMemoryToDevice");
  WriteMemoryToDevice();

  system.timer.check("Begin CalcFutureScore");
  //CalcFutureScore();

  system.timer.check("Begin Search");
  Search();
  
  system.timer.check("Finished Search");
}

Manager::~Manager()
{
  m_system.CleanUpAfterSentenceProcessing(m_sentence);
  RemoveAllInColl(m_inputPathQueue);
}

void Manager::CreateInputPaths()
{
  for (size_t pos = 0; pos < m_sentence.GetSize(); ++pos) {
    Phrase phrase(1);
    phrase.Set(0, m_sentence.GetWord(pos));

    InputPath *path = new InputPath(NULL, phrase, pos, m_system.m_pts.size());
    m_inputPathQueue.push_back(path);

    CreateInputPaths(*path, pos + 1);
  }
}

void Manager::CreateInputPaths(const InputPath &prevPath, size_t pos)
{
  if (pos >= m_sentence.GetSize()) {
    return;
  }

  Phrase phrase(prevPath.GetPhrase(), 1);
  phrase.SetLastWord(m_sentence.GetWord(pos));

  InputPath *path = new InputPath(&prevPath, phrase, pos, m_system.m_pts.size());
  m_inputPathQueue.push_back(path);

  CreateInputPaths(*path, pos + 1);
}

void Manager::Lookup()
{
  for (size_t i = 0; i < m_system.m_pts.size(); ++i) {
    PhraseTable &pt = *m_system.m_pts[i];
    pt.Lookup(m_inputPathQueue);
  }
}

void Manager::Search()
{
	cerr << "Searching..." << endl;
	size_t inputSize = m_sentence.GetSize();
	InitStacksHost(inputSize);

	for (size_t i = 0; i < inputSize; ++i) {
		InitStackHost(i);
		ProcessStackHost(i);
		FinalizeStackHost(i);
	}

	DebugStacks(inputSize);
}

void Manager::WriteMemoryToDevice()
{
	InitInputInfo(m_sentence.GetSize(), m_inputPathQueue.size());

	for (size_t i = 0; i < m_inputPathQueue.size(); ++i) {
		const InputPath &path = *m_inputPathQueue[i];
		const WordsRange &range = path.GetRange();
		const PhraseTableLookup &lookup = path.GetPtLookup(0); // TODO
		const TargetPhrases *tpColl = lookup.tpColl;

		void *memtpColl;
		size_t memSize;
		if (tpColl) {

			memtpColl = tpColl->GetMem();
			memSize = tpColl->GetMemSize();
		}
		else {
			memtpColl = NULL;
			memSize = 0;
		}

		SetTargetPhrases(i, memtpColl, memSize, range);
	}

	CompleteInputInfo();

}

}

