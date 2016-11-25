//
//  PhraseVec.h
//  ultra-moses
//
//  Created by Hieu Hoang on 10/11/2013.
//  Copyright (c) 2013 Hieu Hoang. All rights reserved.
//

#pragma once

#include <vector>
#include <string>

namespace FastMoses
{
class Word;

class PhraseVec : public std::vector<const Word*>
{
public:

  std::string Debug() const;
protected:

};

}