#include <iostream>
#include "Manager.h"
#include "Phrase.h"
#include "Hypothesis.h"

using namespace std;

Manager::Manager(const std::string inputStr)
{
  m_input = Phrase::CreateFromString(inputStr);
  cerr << "m_input=" << m_input->Debug() << endl;
  m_stacks.Init(*this, m_input->GetSize() + 1);

  Hypothesis *hypo = new Hypothesis();
  Stack &stack = m_stacks[0];

}


Manager::~Manager()
{
  delete m_input;
}
