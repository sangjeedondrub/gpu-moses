#include <vector>
#include "Scores.h"
#include "Util.h"
#include "FF/FeatureFunction.h"
#include "util/exception.hh"

using namespace std;

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
  for (size_t i = 0; i < scores.size(); ++i) {
    //m_scores.Set(i, scores[i]);
    m_scores[i + ff.startInd] = scores[i];
    m_total += scores[i];
  }

}

__host__
void Scores::PlusEqual(const System &sys, const FeatureFunction &ff, SCORE score)
{
  UTIL_THROW_IF2(1 != ff.numScores, "Wrong number of scores");
  m_scores[ff.startInd] = score;
  m_total += score;
}

__host__
std::string Scores::Debug() const
{
  return m_scores.Debug();
}
