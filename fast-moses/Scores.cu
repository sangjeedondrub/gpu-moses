#include <vector>
#include "Scores.h"
#include "Util.h"

using namespace std;

__host__
void Scores::CreateFromString(const std::string &str)
{
	vector<SCORE> scores;
	Tokenize(scores, str);

	for (size_t i = 0; i < scores.size(); ++i) {
		//m_vec.Set(i, scores[i]);
		m_vec[i] = scores[i];
		m_total += scores[i];
	}
}

__host__
std::string Scores::Debug() const
{
  return m_vec.Debug();
}
