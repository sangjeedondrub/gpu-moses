#include <vector>
#include "Scores.h"
#include "Util.h"

using namespace std;

void Scores::CreateFromString(const std::string &str)
{
	vector<SCORE> scores;
	Tokenize(scores, str);

	for (size_t i = 0; i < scores.size(); ++i) {
		m_vec[i] = scores[i];
	}
}
