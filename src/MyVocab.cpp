/*
 * Vocab.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#include <iostream>
#include <cassert>
#include "MyVocab.h"
#include "Util.h"

using namespace std;

namespace FastMoses
{

MyVocab MyVocab::s_instance;

MyVocab::MyVocab()
{
  // TODO Auto-generated constructor stub
}

VOCABID MyVocab::GetOrCreateId(const std::string &str)
{
  CollInv::const_iterator iter;
  iter = m_collInv.find(str);
  if (iter != m_collInv.end()) {
    return iter->second;
  } else {
    VOCABID currId = m_coll.size();
    m_collInv[str] = currId;

    m_coll.push_back(str);

    return currId;
  }
}

std::vector<VOCABID> MyVocab::GetOrCreateIds(const std::string &str)
{
  vector<string> toks;
  Tokenize(toks, str);

  std::vector<VOCABID> ret(toks.size());

  for (size_t i = 0; i < toks.size(); ++i) {
	  VOCABID vocabId = GetOrCreateId(toks[i]);
	  ret[i] = vocabId;
  }

  return ret;
}

const std::string &MyVocab::GetString(VOCABID id) const
{
  assert(id < m_coll.size());
  const string &str = m_coll[id];
  return str;
}

}
