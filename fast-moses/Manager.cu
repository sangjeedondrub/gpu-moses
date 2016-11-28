#include <iostream>
#include "Manager.h"
#include "Phrase.h"

using namespace std;

Manager::Manager(const std::string inputStr)
{
  m_input = Phrase::CreateFromString(inputStr);
  cerr << "m_input=" << m_input->Debug() << endl;

}


Manager::~Manager()
{
  delete m_input;
}
