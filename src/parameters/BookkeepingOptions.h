// -*- mode: c++; indent-tabs-mode: nil; tab-width: 2 -*-
#pragma once
#include "OptionsBaseClass.h"

class Parameter;

  struct BookkeepingOptions : public OptionsBaseClass 
  {
    bool need_alignment_info;
    bool init(Parameter const& param);
    BookkeepingOptions();
  };
  


