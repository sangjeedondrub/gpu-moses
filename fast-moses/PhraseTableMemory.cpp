/*
 * PhraseTableMemory.cpp
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */

#include "PhraseTableMemory.h"
#include "MyVocab.h"
#include "InputFileStream.h"

PhraseTableMemory::PhraseTableMemory() {
	// TODO Auto-generated constructor stub

}

PhraseTableMemory::~PhraseTableMemory() {
	// TODO Auto-generated destructor stub
}

void PhraseTableMemory::Load(const std::string &path)
{
	FastMoses::InputFileStream strm(path);

}
