#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

unsigned int edit_distance(const std::vector<std::string>& s1, const std::vector<std::string>& s2)
{
	const std::size_t len1 = s1.size(), len2 = s2.size();
	std::vector<std::vector<unsigned int> > d(len1 + 1, std::vector<unsigned int>(len2 + 1));

	d[0][0] = 0;
	for(unsigned int i = 1; i <= len1; ++i) d[i][0] = i;
	for(unsigned int i = 1; i <= len2; ++i) d[0][i] = i;

	for(unsigned int i = 1; i <= len1; ++i)
		for(unsigned int j = 1; j <= len2; ++j)
                      // note that std::min({arg1, arg2, arg3}) works only in C++11,
                      // for C++98 use std::min(std::min(arg1, arg2), arg3)
                      d[i][j] = std::min({ d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + (s1[i - 1] == s2[j - 1] ? 0 : 1) });
	return d[len1][len2];
}

inline std::vector<std::string> Tokenize(const std::string& str,
    const std::string& delimiters = " \t")
{
  std::vector<std::string> tokens;
  // Skip delimiters at beginning.
  std::string::size_type lastPos = str.find_first_not_of(delimiters, 0);
  // Find first "non-delimiter".
  std::string::size_type pos = str.find_first_of(delimiters, lastPos);

  while (std::string::npos != pos || std::string::npos != lastPos) {
    // Found a token, add it to the vector.
    tokens.push_back(str.substr(lastPos, pos - lastPos));
    // Skip delimiters.  Note the "not_of"
    lastPos = str.find_first_not_of(delimiters, pos);
    // Find next "non-delimiter"
    pos = str.find_first_of(delimiters, lastPos);
  }

  return tokens;
}


int main(int argc, char *argv[])
{
  string inPath = argv[1];
  ifstream inStrm;
  inStrm.open(inPath.c_str());
  
  string outPath = argv[2];
  ofstream outStrm;
  outStrm.open(outPath.c_str());
  
  typedef std::vector<std::string> Sentence;
  std::vector<Sentence> sentences;
  
  string line;
  while (getline(inStrm, line)) {
  	Sentence sentence = Tokenize(line);
  	sentences.push_back(sentence);
  }
  inStrm.close();
  
  size_t numSentences = sentences.size();
  cerr << "#sentences=" << numSentences << endl;
  
  for (size_t i = 0; i < numSentences; ++i) {
  	cerr << i << " " << flush;
  	outStrm << i << " " << sentences[i].size() << " : ";
	  for (size_t j = 0; j < i; ++j) {
			const Sentence &sent1 = sentences[i];
			const Sentence &sent2 = sentences[j];
			unsigned int dist = edit_distance(sent1, sent2);

			float perWord = std::min((float)dist/sent1.size(), (float)dist/sent2.size());
  		//outStrm << dist << "|" << perWord << " ";
  		outStrm << j << "=" << perWord << " ";
  	}
  	outStrm << endl;
  }
  
  outStrm.close();
	cerr << "FInished" << endl;
}

