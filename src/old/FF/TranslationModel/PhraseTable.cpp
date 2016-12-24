/*
 * PhraseTable.cpp
 *
 *  Created on: 5 Oct 2013
 *      Author: hieu
 */

#include "PhraseTable.h"
#include "InputPath.h"

namespace FastMoses
{

PhraseTable::PhraseTable(const std::string line, const System &system)
  :StatelessFeatureFunction(line, system)
{
}

PhraseTable::~PhraseTable()
{
  // TODO Auto-generated destructor stub
}

}

