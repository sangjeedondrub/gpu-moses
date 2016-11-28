/*
 * Manager.h
 *
 *  Created on: 28 Nov 2016
 *      Author: hieu
 */

#pragma once
#include <string>
#include "Stacks.h"

class Phrase;

class Manager
{
public:
	Manager(const std::string inputStr);
	virtual ~Manager();
protected:
	Phrase *m_input;
	Stacks m_stacks;
};



