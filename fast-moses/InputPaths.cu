#include "InputPaths.h"
#include "InputPath.h"
#include "Phrase.h"
#include "Range.h"

void InputPaths::Init(const Phrase &input, const Manager &mgr)
{
  Range range(NOT_FOUND, NOT_FOUND);
  m_blank = new InputPath();

  size_t size = input.GetSize();

}
