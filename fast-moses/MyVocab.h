/*
 * Vocab.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */
#pragma once

#include <map>
#include <vector>
#include "TypeDef.h"

namespace FastMoses
{

class MyVocab
{
public:
  static MyVocab &Instance() {
    return s_instance;
  }

  MyVocab();
  MyVocab(const MyVocab &copy); // do not implement
  virtual ~MyVocab()
  {}

  VOCABID GetOrCreateId(const std::string &str);
  const std::string &GetString(VOCABID id) const;
protected:
  static MyVocab s_instance;

  typedef std::vector<std::string> Coll;
  Coll m_coll;

  typedef std::map<std::string, VOCABID > CollInv;
  CollInv m_collInv;


};

}
