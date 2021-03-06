#include <iostream>
#include "CUDA/Util.h"
#include "Stack.h"
#include "Hypothesis.h"
#include "Manager.h"
#include "System.h"

using namespace std;


Stack::Stack(const Manager &mgr)
:m_coll()
,m_tolerance(mgr.system.options.search.stack_size * 2)
{
  //mgr.system.params.
  m_coll.GetVec().Reserve(m_tolerance);

  cudaDeviceSynchronize();
  //cerr << "m_arr=" << m_arr << endl;

  //debugStr[0] = 0x0;
}

__host__
Stack::~Stack()
{
  for (size_t i = 0; i < m_coll.size(); ++i) {
    Hypothesis *hypo = m_coll.GetVec()[i];
    cudaFree(hypo);
  }
}

__device__
void Stack::add(Hypothesis *hypo)
{
  if (m_coll.size() >= m_tolerance) {
    prune(*hypo->mgr);
  }
  /*
  StrCat(debugStr, "hypo=");
  StrCat(debugStr, itoaDevice((size_t) hypo));
  */
  thrust::pair<bool, size_t> upper = m_coll.upperBound(hypo);
  if (upper.first) {
    // same hypo exist
    const Hypothesis *otherHypo = m_coll.GetVec()[upper.second];

    SCORE newScore = hypo->getFutureScore();
    SCORE otherScore = otherHypo->getFutureScore();

    if (newScore > otherScore) {
      // new hypo is better
      /*
      StrCat(debugStr, " ADDED winner=");

      char str[500];

      str[0] = 0x0;
      hypo->Debug(str);
      StrCat(debugStr,  str);

      StrCat(debugStr,  "\nloser=");
      str[0] = 0x0;
      otherHypo->Debug(str);
      StrCat(debugStr,  str);

      //StrCat(debugStr,  itoaDevice((size_t) otherHypo));
      StrCat(debugStr, "\n");
      */
      delete otherHypo;
      m_coll.GetVec()[upper.second] = hypo;
    }
    else {
      // existing hypo is better
      //StrCat(debugStr, " not ADDED\n");
      delete hypo;
    }
  }
  else {
    //StrCat(debugStr, " ADDED\n");
    m_coll.insert(hypo);
    //(*m_arr)[m_size] = hypo;
  }
}

__device__
void Stack::prune(const Manager &mgr)
{
  if (m_coll.size() < mgr.system.options.search.stack_size) {
      return;
  }

  // sort hypos into score order
  Array<Hypothesis*> sortedHypos(0);
  sortedHypos.reserve(m_coll.size());

  const Vector<Hypothesis*> &vec = m_coll.GetVec();
  for (size_t i = 0; i < vec.size(); ++i) {
    Hypothesis *hypo = vec[i];
    thrust::pair<bool, size_t> upper = sortedHypos.upperBound<HypothesisFutureScoreOrderer>(hypo);
    sortedHypos.insert(upper.second, hypo);
  }

  // add back into m_coll
  m_coll.GetVec().Clear();

  for (size_t i = 0; i < mgr.system.options.search.stack_size; ++i) {
    Hypothesis *hypo = sortedHypos[i];

    m_coll.insert(hypo);
  }

  for (size_t i = mgr.system.options.search.stack_size; i < sortedHypos.size(); ++i) {
    Hypothesis *hypo = sortedHypos[i];
    delete hypo;
  }
}


__host__
std::string Stack::Debug() const
{
  std::stringstream strm;
  size_t size = GetSize();
  strm << "stack size=" << size << endl;
  for (size_t i = 0; i < size; ++i) {
    //cerr << "HH1:" << i << endl;
    const Hypothesis *hypo = m_coll.GetVec()[i];
    //cerr << "HH2:" << hypo << endl;

    //cerr << "HH3:" << h_s << endl;
    strm << "hypo= " << hypo->Debug() << endl;
  }

  return strm.str();
}
