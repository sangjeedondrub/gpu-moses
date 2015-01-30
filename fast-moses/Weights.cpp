
#include <cassert>
#include "Weights.h"
#include "Util.h"
#include "System.h"
#include "FF/FeatureFunction.h"

using namespace std;

namespace FastMoses {

Weights::Weights()
{
  // TODO Auto-generated constructor stub

}

Weights::~Weights()
{
  // TODO Auto-generated destructor stub
}

void Weights::CreateFromString(const std::string &line)
{
  Tokenize<SCORE>(m_weights, line);

}

void Weights::SetWeights(const FeatureFunction &ff, const std::vector<SCORE> &weights)
{
  size_t numScores = ff.GetNumScores();
  assert(numScores == weights.size());
  size_t startInd = ff.GetStartInd();

  size_t inInd = 0;
  for (size_t i = startInd; i < startInd + numScores; ++i, ++inInd) {
    m_weights[i] = weights[inInd];
  }
}

}
