#include <vector>
#include "Scores.h"
#include "Util.h"
#include "System.h"
#include "FF/FeatureFunction.h"
#include "util/exception.hh"

using namespace std;

Scores::Scores(size_t size)
:m_scores(size)
,m_total(0)
{
  for (size_t i = 0; i < size; ++i) {
    m_scores[i] = 0;
  }
}

__host__
void Scores::CreateFromString(const System &system, const FeatureFunction &ff, const std::string &str, bool transformScores)
{
	vector<SCORE> scores;
	Tokenize(scores, str);

  if (transformScores) {
    std::transform(scores.begin(), scores.end(), scores.begin(),
        TransformScore);
    std::transform(scores.begin(), scores.end(), scores.begin(), FloorScore);
  }

	PlusEqual(system, ff, scores);
}

__host__
void Scores::PlusEqual(const System &sys, const FeatureFunction &ff, const std::vector<SCORE> &scores)
{
  UTIL_THROW_IF2(scores.size() != ff.numScores, "Wrong number of scores");

  const Vector<SCORE> &weights = sys.weights;
  for (size_t i = 0; i < scores.size(); ++i) {
    //m_scores.Set(i, scores[i]);
    m_scores[i + ff.startInd] = scores[i];
    m_total += scores[i] * weights[i + ff.startInd];
  }

}

__host__
void Scores::PlusEqual(const System &sys, const FeatureFunction &ff, SCORE score)
{
  UTIL_THROW_IF2(1 != ff.numScores, "Wrong number of scores");

  const Vector<SCORE> &weights = sys.weights;
  m_scores[ff.startInd] = score;
  m_total += score * weights[ff.startInd];
}

__host__
std::string Scores::Debug() const
{
  return m_scores.Debug();
}
