/*
 * Sentence.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#pragma once

#include "Phrase.h"

namespace FastMoses
{

class Sentence :public Phrase
{
public:
  static Sentence *CreateFromString(const std::string &line);

  Sentence(size_t size);
  virtual ~Sentence();
};

}

