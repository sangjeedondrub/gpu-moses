/*
 * FeatureFunction.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */

#include <cassert>
#include <set>
#include "FeatureFunction.h"
#include "Util.h"
#include "System.h"
#include "TargetPhrase.h"

using namespace std;

namespace FastMoses {

FeatureFunction::FeatureFunction(const std::string &line, const System &system)
  : m_numScores(1)
  ,m_system(system)
{
  std::string featureName;

  ParseLine(line, featureName);
  CreateName(featureName, system);
}

FeatureFunction::~FeatureFunction()
{
  // TODO Auto-generated destructor stub
}

void FeatureFunction::ReadParameters()
{
  while (!m_args.empty()) {
    const vector<string> &args = m_args[0];
    SetParameter(args[0], args[1]);

    m_args.erase(m_args.begin());
  }

}

void FeatureFunction::SetParameter(const std::string& key, const std::string& value)
{

}

void FeatureFunction::ParseLine(const std::string &line, std::string &featureName)
{
  vector<string> toks;
  Tokenize(toks, line);

  featureName = toks[0];

  for (size_t i = 1; i < toks.size(); ++i) {
    vector<string> args = TokenizeFirstOnly(toks[i], "=");
    assert(args.size() == 2);

    if (args[0] == "num-features") {
      m_numScores = Scan<size_t>(args[1]);
    } else if (args[0] == "name") {
      m_name = args[1];
    } else {
      m_args.push_back(args);
    }
  }
}

void FeatureFunction::CreateName(const std::string &featureName, const System &system)
{
  if (m_name.empty()) {
    std::map<std::string, size_t>::const_iterator iter;
    iter = system.m_nameInd.find(featureName);
    if (iter == system.m_nameInd.end()) {
      system.m_nameInd[featureName] = 0;
      m_name = featureName + SPrint(0);
    } else {
      size_t num = iter->second;
      m_name = featureName + SPrint(num);
    }
  }
}

void FeatureFunction::Register(size_t &nextInd)
{
  m_startInd = nextInd;
  nextInd += m_numScores;
  
  cerr << m_name << "=" << m_startInd << "-" << (m_startInd+m_numScores-1) << endl;
}

}
