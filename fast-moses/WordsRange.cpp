/*
 * WordsRange.cpp
 *
 *  Created on: Oct 6, 2013
 *      Author: hieuhoang
 */
#include <sstream>
#include <stdlib.h>
#include "WordsRange.h"
#include "Util.h"

using namespace std;

namespace FastMoses
{

WordsRange::WordsRange(const WordsRange &prevRange, size_t phraseSize)
{
  startPos = prevRange.endPos + 1;
  endPos = prevRange.endPos + phraseSize;
}

WordsRange::~WordsRange()
{
}

bool WordsRange::operator==(const WordsRange &other) const
{
  return (startPos == other.startPos) && (endPos == other.endPos);
}

std::string WordsRange::Debug() const
{
  stringstream strme;
  strme << "[" << startPos << "," << endPos << "]";
  return strme.str();
}

int WordsRange::ComputeDistortionScore(const WordsRange &next) const
{
  int dist = 0;
  if (GetNumWordsCovered() == 0) {
    dist = next.startPos;
  } else {
    dist = (int)endPos - (int)next.startPos + 1 ;
  }
  return -abs(dist);
}

}
