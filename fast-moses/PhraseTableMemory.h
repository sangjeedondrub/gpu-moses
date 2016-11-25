/*
 * PhraseTableMemory.h
 *
 *  Created on: 25 Nov 2016
 *      Author: hieu
 */
#pragma once
#include <string>

class Node
{

protected:

};

class PhraseTableMemory
{
public:
	PhraseTableMemory();
	virtual ~PhraseTableMemory();

	void Load(const std::string &path);

protected:
	Node m_root;
};

