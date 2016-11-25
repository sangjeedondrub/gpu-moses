//
//  PhraseVec.cpp
//  ultra-moses
//
//  Created by Hieu Hoang on 10/11/2013.
//  Copyright (c) 2013 Hieu Hoang. All rights reserved.
//
#include <sstream>
#include "PhraseVec.h"
#include "Word.h"

using namespace std;

namespace FastMoses
{

std::string PhraseVec::Debug() const
{
  stringstream strme;
  
  for (size_t i = 0; i < size(); ++i) {
    const Word &word = *at(i);
    strme << word.Debug();
  }
  
  return strme.str();
}

}

