/*
 * Util.cpp
 *
 *  Created on: Aug 17, 2013
 *      Author: hieuhoang
 */
#include <set>
#include <fstream>

#include <ctype.h>
#if !defined(_WIN32) && !defined(_WIN64)
#include <sys/resource.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#endif

#include "Util.h"

#if !defined(_WIN32) && !defined(_WIN64)
namespace {
  
  // On Mac OS X, clock_gettime is not implemented.
  // CLOCK_MONOTONIC is not defined either.
#ifdef __MACH__
//#define CLOCK_MONOTONIC 0
  /*
  int clock_gettime(int clk_id, struct timespec *tp) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    tp->tv_sec = tv.tv_sec;
    tp->tv_nsec = tv.tv_usec * 1000;
    return 0;
  }
  */
#endif // __MACH__
  
  float FloatSec(const struct timeval &tv) {
    return static_cast<float>(tv.tv_sec) + (static_cast<float>(tv.tv_usec) / 1000000.0);
  }
  float FloatSec(const struct timespec &tv) {
    return static_cast<float>(tv.tv_sec) + (static_cast<float>(tv.tv_nsec) / 1000000000.0);
  }
  
  const char *SkipSpaces(const char *at) {
    for (; *at == ' ' || *at == '\t'; ++at) {}
    return at;
  }
  
  class RecordStart {
  public:
    RecordStart() {
      clock_gettime(CLOCK_MONOTONIC, &started_);
    }
    
    const struct timespec &Started() const {
      return started_;
    }
    
  private:
    struct timespec started_;
  };
  
  const RecordStart kRecordStart;
} // namespace
#endif


const std::string Trim(const std::string& str, const std::string dropChars)
{
  std::string res = str;
  res.erase(str.find_last_not_of(dropChars)+1);
  return res.erase(0, res.find_first_not_of(dropChars));
}

void PrintUsage(std::ostream &out) {
#if !defined(_WIN32) && !defined(_WIN64)
  // Linux doesn't set memory usage in getrusage :-(
  std::set<std::string> headers;
  headers.insert("VmPeak:");
  headers.insert("VmRSS:");
  headers.insert("Name:");
  
  std::ifstream status("/proc/self/status", std::ios::in);
  std::string header, value;
  while ((status >> header) && getline(status, value)) {
    if (headers.find(header) != headers.end()) {
      out << header << SkipSpaces(value.c_str()) << '\t';
    }
  }
  
  struct rusage usage;
  if (getrusage(RUSAGE_SELF, &usage)) {
    perror("getrusage");
    return;
  }
  out << "RSSMax:" << usage.ru_maxrss << " kB" << '\t';
  out << "user:" << FloatSec(usage.ru_utime) << "\tsys:" << FloatSec(usage.ru_stime) << '\t';
  out << "CPU:" << (FloatSec(usage.ru_utime) + FloatSec(usage.ru_stime));
  
  struct timespec current;
  clock_gettime(CLOCK_MONOTONIC, &current);
  out << "\treal:" << (FloatSec(current) - FloatSec(kRecordStart.Started())) << '\n';
#endif
}
