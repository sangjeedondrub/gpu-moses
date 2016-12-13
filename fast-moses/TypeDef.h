/*
 * TypeDef.h
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */
#pragma once

#include <limits>

typedef float SCORE;
typedef int VOCABID;

#define NOT_FOUND                       std::numeric_limits<size_t>::max()
#define NOT_FOUND_DEVICE                12345

const SCORE LOWEST_SCORE = -100.0;

#ifndef BOS_
#define BOS_ "<s>" //Beginning of sentence symbol
#endif
#ifndef EOS_
#define EOS_ "</s>" //End of sentence symbol
#endif

#ifdef WIN32
#include <BaseTsd.h>
#else
#include <stdint.h>
typedef uint32_t UINT32;
typedef uint64_t UINT64;
#endif

#define NUM_SCORES 5
