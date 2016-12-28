// -*- mode: c++; indent-tabs-mode: nil; tab-width: 2 -*-
#pragma once
#include <string>
#include "OptionsBaseClass.h"

  struct 
  BeamSearchOptions : public OptionsBaseClass
  {
    bool init(Parameter const& param);
    BeamSearchOptions(Parameter const& param);
  };

