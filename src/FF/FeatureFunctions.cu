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
#include "../LM/LanguageModel.h"

using namespace std;


FeatureFunctions::FeatureFunctions(System &system)
:m_system(system)
,ffs(0)
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
      ff = new Distortion(totalNumScores, line);
    }
    else if (toks[0] == "WordPenalty") {
      ff = new WordPenalty(totalNumScores, line);
    }
    else if (toks[0] == "PhraseDictionaryMemory") {
      ff = new PhraseTableMemory(totalNumScores, line);
    }
    else if (toks[0] == "UnknownWordPenalty") {
      ff = new UnknownWordPenalty(totalNumScores, line);
    }
    else if (toks[0] == "LanguageModel") {
      ff = new LanguageModel(totalNumScores, line);
    }
    else {
      UTIL_THROW2("Unknown FF:" << line);
    }

    // put into correct vector
    assert(ff);
    cerr << "created "
        << ff->GetName() << " "
        << ff->startInd << " "
        << ff->numScores
        << endl;
    totalNumScores += ff->numScores;

    ffs.PushBack(ff);

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

__host__
const FeatureFunction *FeatureFunctions::FindFeatureFunction(
    const std::string &name) const
{
  for (size_t i = 0; i < ffs.size(); ++i) {
    const FeatureFunction *ff = ffs[i];
    if (ff->GetName() == name) {
    return ff;
    }
  }
  return NULL;
}

__host__
void FeatureFunctions::EvaluateInIsolation(const Phrase &source, TargetPhrase &targetPhrase) const
{
  Scores &scores = targetPhrase.GetScores();
  SCORE estimatedScore = 0;

  for (size_t i = 0; i < statelessFFs.size(); ++i) {
    const FeatureFunction *ff = statelessFFs[i];
    ff->EvaluateInIsolation(m_system, source, targetPhrase, scores, estimatedScore);
  }
}

__device__
void FeatureFunctions::EvaluateWhenApplied(const Manager &mgr, Hypothesis &hypo) const
{
  for (size_t i = 0; i < statefulFFs.size(); ++i) {
    const StatefulFeatureFunction *sfff = statefulFFs[i];

    switch (sfff->classId) {
    case FeatureFunction::ClassId::Distortion:
    {
      const Distortion *castFF = static_cast<const Distortion*>(sfff);
      castFF->EvaluateWhenApplied(mgr, hypo);
      break;
    }
    case FeatureFunction::ClassId::LanguageModel:
    {
      const LanguageModel *castFF = static_cast<const LanguageModel*>(sfff);
      castFF->EvaluateWhenApplied(mgr, hypo);
      break;
    }
    default:
    {
      __threadfence();         // ensure store issued before trap
      asm("trap;");
    }
    }
  }

}


