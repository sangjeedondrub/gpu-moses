/*
 * Phrase.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#include <stdlib.h>
#include <iostream>
#include <sstream>
#include "Phrase.h"
#include "Util.h"

using namespace std;

namespace FastMoses
{

Phrase::Phrase(size_t size)
  :m_words(size)
{
}

Phrase::Phrase(const Phrase &copy)
:m_words(copy.m_words)
{
}

Phrase::Phrase(const Phrase &copy, size_t extra)
:m_words(copy.GetSize() + extra)
{
  for (size_t i = 0; i < copy.GetSize(); ++i) {
    const Word &word = copy.GetWord(i);
    Set(i, word);
  }
}

Phrase::~Phrase()
{
}

void Phrase::Set(size_t pos, const Word &word)
{
  m_words[pos].Set(word);
}


void Phrase::Output(std::ostream &out) const
{
  for (size_t i = 0; i < GetSize(); ++i) {
    const Word &word = m_words[i];
    word.Output(out);
    out << " ";
  }
}

std::string Phrase::Debug() const
{
  stringstream strme;
  for (size_t i = 0; i < GetSize(); ++i) {
    const Word &word = m_words[i];
    strme << word.Debug() << " ";
  }

  return strme.str();
}

Phrase *Phrase::CreateFromString(const std::string &line)
{
  vector<string> toks;
  Tokenize(toks, line);
  Phrase *phrase = new Phrase(toks.size());

  for (size_t i = 0; i < toks.size(); ++i) {
    Word &word = phrase->GetWord(i);
    word.CreateFromString(toks[i]);
  }

  return phrase;
}

Phrase *Phrase::GetSubPhrase(size_t startPos, size_t endPos) const
{
	Phrase *ret = new Phrase(endPos - startPos + 1);

	size_t newPos = 0;
	for (size_t currPos = startPos; currPos <= endPos; ++currPos) {
		ret->Set(newPos, GetWord(currPos));

		++newPos;
	}
}

}
