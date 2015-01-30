/*
 * InputPath.cpp
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#include <stdlib.h>
#include "InputPath.h"
#include "FF/TranslationModel/PhraseTable.h"

namespace FastMoses {

InputPath::InputPath(const InputPath *prevPath, const Phrase &phrase, size_t endPos, size_t numPts)
  :m_lookupColl(numPts)
  ,m_prevPath(prevPath)
  ,m_phrase(phrase)
  ,m_range(prevPath ? prevPath->GetRange().startPos : endPos, endPos)
{
}

InputPath::~InputPath()
{
}

}

