/*
 * Phrase.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#pragma once

#include <vector>
#include <string>
#include <cassert>
#include "Word.h"

namespace FastMoses
{

class Phrase
{
public:
  static Phrase *CreateFromString(const std::string &line);

  Phrase(size_t size);
  Phrase(const Phrase &copy);
  Phrase(const Phrase &copy, size_t extra);

  virtual ~Phrase();

  const Word &GetWord(size_t pos) const {
    return m_words[pos];
  }
  Word &GetWord(size_t pos) {
    assert(pos < GetSize());
    return m_words[pos];
  }
  const Word &Back() const {
    assert(GetSize());
    return m_words[GetSize() - 1];
  }

  size_t GetSize() const {
    return m_words.size();
  }

  void Set(size_t pos, const Word &word);
  void SetLastWord(const Word &word) {
    Set(GetSize() - 1, word);
  }

  Phrase *GetSubPhrase(size_t startPos, size_t endPos) const;

  void Output(std::ostream &out) const;
  virtual std::string Debug() const;

protected:
  std::vector<Word> m_words;
  //Word *m_words;
};

}

