/*
 * System.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */
#include <iostream>
#include <cassert>
#include "System.h"
#include "InputFileStream.h"
#include "Util.h"

#include "FF/FeatureFunction.h"
#include "FF/TranslationModel/PhraseTableMemory.h"
#include "FF/TranslationModel/UnknownWordPenalty.h"
#include "FF/StatefulFeatureFunction.h"

using namespace std;

namespace FastMoses
{

System::System()
:m_nextInd(0)
{
  
}
  
System::~System()
{
  RemoveAllInColl(m_ffs);
  if (m_inputStrme != &cin) {
    delete m_inputStrme;
  }
  
}

void System::Init(int argc, char** argv)
{
  for (int i = 0; i < argc; ++i) {
    string arg = argv[i];
    if (arg == "-f") {
      m_iniPath = argv[++i];
    } else if (arg == "-i") {
      m_inputPath = argv[++i];
    }
  }

  // input file
  if (m_inputPath.empty()) {
    m_inputStrme = &cin;
  } else {
    m_inputStrme = new InputFileStream(m_inputPath);
  }

  // read ini file
  InputFileStream iniStrme(m_iniPath);

  ParamList *paramList = NULL;
  string line;
  while (getline(iniStrme, line)) {
    line = Trim(line);
    if (line.find("[") == 0) {
      paramList = &m_params[line];
    } else if (line.find("#") == 0 || line.empty()) {
      // do nothing
    } else {
      paramList->push_back(line);
    }
  }

  timer.check("InitParams");
  InitParams();
  timer.check("InitFF");
  InitFF();
  timer.check("InitWeight");
  InitWeight();
  timer.check("Start Load");
  Load();
  timer.check("Finished Load");
}
  
/** load all parameters from the configuration file and the command line switches */
void System::Init(const char *iniPath)
{
  const char *argv[] = {"executable", "-f", iniPath };
  return Init(3, (char**) argv);
}

bool System::ParamExist(const std::string &key) const
{
  Params::const_iterator iter;
  iter = m_params.find(key);
  bool ret = (iter != m_params.end());
  return ret;
}

void System::InitParams()
{
  if (ParamExist("[stack]")) {
    stackSize = Scan<size_t>(m_params["[stack]"][0]);
  } else {
    stackSize = 200;
  }

  if (ParamExist("[distortion-limit]")) {
    maxDistortion = Scan<int>(m_params["[distortion-limit]"][0]);
  } else {
    maxDistortion = 6;
  }
}

void System::InitFF()
{
  ParamList &list =	m_params["[feature]"];

  for (size_t i = 0; i < list.size(); ++i) {
    string &line = list[i];
    cerr << "line=" << line << endl;

    FeatureFunction *ff = NULL;
    if (line.find("PhraseDictionaryMemory") == 0) {
      ff = new PhraseTableMemory(line, *this);
    } else {
      cerr << "Unknown FF " << line << endl;
      abort();
    }
    
    ff->Register(m_nextInd);

    m_ffs.push_back(ff);
    if (ff->IsStateless()) {
      StatelessFeatureFunction *slff = static_cast<StatelessFeatureFunction*>(ff);
      m_slffs.push_back(slff);
    }
    else {
      StatefulFeatureFunction *sfff = static_cast<StatefulFeatureFunction*>(ff);
      m_sfffs.push_back(sfff);
    }

    if (ff->IsPhraseTable()) {
      PhraseTable *pt = static_cast<PhraseTable*>(ff);
      m_pts.push_back(pt);
    }
  }
}

void System::InitWeight()
{
  weights.SetNumScores(GetTotalNumScores());
  ParamList &list =	m_params["[weight]"];

  for (size_t i = 0; i < list.size(); ++i) {
    string &line = list[i];
    cerr << "line=" << line << endl;

    vector<string> toks = TokenizeFirstOnly(line, "=");
    assert(toks.size() == 2);

    FeatureFunction &ff = FindFeatureFunction(toks[0]);

    vector<SCORE> featureWeights;
    Tokenize<SCORE>(featureWeights, toks[1]);
    assert(ff.GetNumScores() == featureWeights.size());
    weights.SetWeights(ff, featureWeights);

    cerr << ff.GetName() << ":" << ff.GetStartInd() << "-" << (ff.GetStartInd() + ff.GetNumScores() - 1) << endl;
  }
}

void System::Load()
{
  cerr << "Loading" << endl;
  for (size_t i = 0; i < m_ffs.size(); ++i) {
    FeatureFunction *ff = m_ffs[i];
    if (ff->IsPhraseTable()) {
      // load pt after other ff
    } else {
      cerr << ff->GetName() << endl;
      ff->Load();
    }
  }

  // load pt
  for (size_t i = 0; i < m_pts.size(); ++i) {
    cerr << m_pts[i]->GetName() << endl;
    PhraseTable &pt = *m_pts[i];
    pt.SetPtId(i);
    pt.Load();
  }
}

FeatureFunction &System::FindFeatureFunction(const std::string& name)
{
  for (size_t i = 0; i < m_ffs.size(); ++i) {
    FeatureFunction &ff = *m_ffs[i];
    if (ff.GetName() == name) {
      return ff;
    }
  }
  
  throw "Unknown feature " + name;
}

void System::Initialize(const Sentence &source)
{
  for (size_t i = 0; i < m_ffs.size(); ++i) {
    FeatureFunction &ff = *m_ffs[i];
    ff.InitializeForInput(source);
  }
}

void System::CleanUpAfterSentenceProcessing(const Sentence &source)
{
  for (size_t i = 0; i < m_ffs.size(); ++i) {
    FeatureFunction &ff = *m_ffs[i];
    ff.CleanUpAfterSentenceProcessing(source);
  }
}

std::string System::Debug() const
{
  stringstream strme;
  strme << "Num FF=" << m_ffs.size()
		<< " StatelessFF=" << m_slffs.size()
		<< " StatefulFF=" << m_sfffs.size();
  strme << endl;
  for (size_t i = 0; i < m_ffs.size(); ++i) {
	  const FeatureFunction &ff = *m_ffs[i];
	  strme << ff.GetName() << ":" << ff.GetStartInd() << "-" << (ff.GetStartInd() + ff.GetNumScores() - 1) << endl;
  }

  return strme.str();
}

}

