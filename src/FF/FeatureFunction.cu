#include <set>
#include "FeatureFunction.h"
#include "util/exception.hh"
#include "../Util.h"

using namespace std;

FeatureFunction::FeatureFunction(size_t startIndArg, const std::string &line)
:startInd(startIndArg)
,numScores(1)
{
  ParseLine(line);
}

void FeatureFunction::ParseLine(const std::string &line)
{
  vector<string> toks = Tokenize(line);
  UTIL_THROW_IF2(toks.empty(), "Empty line");

  string nameStub = toks[0];

  set<string> keys;

  for (size_t i = 1; i < toks.size(); ++i) {
    vector<string> args = TokenizeFirstOnly(toks[i], "=");
    UTIL_THROW_IF2(args.size() != 2,
        "Incorrect format for feature function arg: " << toks[i]);

    pair<set<string>::iterator, bool> ret = keys.insert(args[0]);
    UTIL_THROW_IF2(!ret.second, "Duplicate key in line " << line);

    if (args[0] == "num-features") {
      numScores = Scan<size_t>(args[1]);
    }
    else if (args[0] == "name") {
      m_name = args[1];
    }
    else {
      m_args.push_back(args);
    }
  }
}

void FeatureFunction::SetParameter(const std::string& key,
    const std::string& value)
{
  if (key == "tuneable") {
    m_tuneable = Scan<bool>(value);
  }
  else {
    UTIL_THROW2(GetName() << ": Unknown argument " << key << "=" << value);
  }
}

void FeatureFunction::ReadParameters()
{
  while (!m_args.empty()) {
    const vector<string> &args = m_args[0];
    SetParameter(args[0], args[1]);

    m_args.erase(m_args.begin());
  }
}
