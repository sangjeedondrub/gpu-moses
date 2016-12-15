/*
 * FeatureFunction.h
 *
 *  Created on: 12 Dec 2016
 *      Author: hieu
 */
#include <vector>
#include <boost/foreach.hpp>
#include "FeatureFunctions.h"
#include "Distortion.h"
#include "WordPenalty.h"
#include "UnknownWordPenalty.h"
#include "../Parameter.h"
#include "../System.h"
#include "../TranslationModel/PhraseTableMemory.h"

using namespace std;


FeatureFunctions::FeatureFunctions(System &system)
:m_system(system)
,statelessFFs(0)
,statefulFFs(0)
{

}

FeatureFunctions::~FeatureFunctions()
{
  cudaFree(pt);
  for (size_t i = 0; i < statelessFFs.size(); ++i) {
    cudaFree(statelessFFs[i]);
  }
  for (size_t i = 0; i < statefulFFs.size(); ++i) {
    cudaFree(statefulFFs[i]);
  }
}

__host__
void FeatureFunctions::Create()
{
  const Parameter &params = m_system.params;

  const PARAM_VEC *ffParams = params.GetParam("feature");
  UTIL_THROW_IF2(ffParams == NULL, "Must have [feature] section");

  totalNumScores = 0;
  totalStateSize = 0;

  BOOST_FOREACH(const std::string &line, *ffParams){
    cerr << "line=" << line << endl;
    vector<string> toks = Tokenize(line);
    assert(toks.size());

    FeatureFunction *ff;
    if (toks[0] == "Distortion") {
      ff = new Distortion();
    }
    else if (toks[0] == "WordPenalty") {
      ff = new WordPenalty();
    }
    else if (toks[0] == "PhraseDictionaryMemory") {
      ff = new PhraseTableMemory();
    }
    else if (toks[0] == "UnknownWordPenalty") {
      ff = new UnknownWordPenalty();
    }
    else {
      UTIL_THROW2("Unknown FF:" << line);
    }

    // put into correct vector
    assert(ff);
    ff->startInd = totalNumScores;
    totalNumScores += ff->numScores;

    StatefulFeatureFunction *sfff = dynamic_cast<StatefulFeatureFunction*>(ff);
    PhraseTableMemory *pt = dynamic_cast<PhraseTableMemory*>(ff);

    if (sfff) {
      sfff->stateOffset = totalStateSize;
      totalStateSize += sfff->stateSize;

      statefulFFs.PushBack(sfff);
    }
    else if (pt) {
      this->pt = pt;
    }
    else {
      statelessFFs.PushBack(ff);
    }


  }

  cerr << "statelessFFs=" << statelessFFs.size() << endl;
  cerr << "statefulFFs=" << statefulFFs.size() << endl;
  cerr << "totalNumScores=" << totalNumScores << endl;
  cerr << "totalStateSize=" << totalStateSize << endl;

}

__host__
void FeatureFunctions::Load()
{
  for (size_t i = 0; i < statelessFFs.size(); ++i) {
    statelessFFs[i]->Load(m_system);
  }
  for (size_t i = 0; i < statefulFFs.size(); ++i) {
    statefulFFs[i]->Load(m_system);
  }
  pt->Load(m_system);
}

__device__
void FeatureFunctions::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  for (size_t i = 0; i < statefulFFs.size(); ++i) {
    const StatefulFeatureFunction *sfff = statefulFFs[i];

    switch (sfff->classId) {
    case FeatureFunction::ClassId::Distortion:
      const Distortion *castFF = static_cast<const Distortion*>(sfff);
      castFF->EvaluateWhenApplied(mgr, hypo);
      break;

    }
  }

}


