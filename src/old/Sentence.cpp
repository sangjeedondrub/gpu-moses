/*
 * Sentence.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#include <stdlib.h>
#include "Sentence.h"
#include "Util.h"

using namespace std;

namespace FastMoses
{

Sentence::Sentence(size_t size)
  :Phrase(size)
{
  // TODO Auto-generated constructor stub

}

Sentence::~Sentence()
{
}

Sentence *Sentence::CreateFromString(const std::string &line)
{
  vector<string> toks;
  Tokenize(toks, line);
  Sentence *phrase = new Sentence(toks.size());

  for (size_t i = 0; i < toks.size(); ++i) {
    Word &word = phrase->GetWord(i);
    word.CreateFromString(toks[i]);
  }

  return phrase;
}

}

