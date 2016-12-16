/* Copyright (C) 1989, 1990, 1991, 1992 Free Software Foundation, Inc.
     Written by James Clark (jjc@jclark.com)

This file is part of groff.

groff is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2, or (at your option) any later
version.

groff is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with groff; see the file COPYING.  If not, write to the Free Software
Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. */
#include <string.h>
#include <cuda.h>

#define INT_DIGITS 19		/* enough for 64 bit integer */

__device__
char *itoaDevice(int i)
{
  /* Room for INT_DIGITS digits, - and '\0' */
  static char buf[INT_DIGITS + 2];
  char *p = buf + INT_DIGITS + 1;	/* points to terminating '\0' */
  if (i >= 0) {
    do {
      *--p = '0' + (i % 10);
      i /= 10;
    } while (i != 0);
    return p;
  }
  else {			/* i < 0 */
    do {
      *--p = '0' - (i % 10);
      i /= 10;
    } while (i != 0);
    *--p = '-';
  }
  return p;
}

__device__
size_t strlenDevice(const char *str)
{
  register const char *s;

  for (s = str; *s; ++s);
  return(s - str);
}


__device__ void MemCpy(char *dest, const char *src, size_t count)
{
  for (size_t i = 0; i < count; ++i) {
    dest[i] = src[i];
  }
}

__device__ void StrCpy(char *dest, const char *src)
{
  size_t len = strlenDevice(src);
  MemCpy(dest, src, len + 1);
}

__device__ char *StrCat(char *dest, const char *src)
{
  StrCpy(&dest[strlenDevice(dest)], src);
  return dest;
}

__device__
static const double powers_of_10[] = { 1, 10, 100, 1000, 10000, 100000, 1000000,
    10000000, 100000000, 1000000000 };

__device__
static void strreverse(char* begin, char* end)
{
    char aux;
    while (end > begin)
        aux = *end, *end-- = *begin, *begin++ = aux;
}

__device__
size_t modp_dtoa(double value, char* str, int prec)
{
    /* Hacky test for NaN
   * under -fast-math this won't work, but then you also won't
   * have correct nan values anyways.  The alternative is
   * to link with libmath (bad) or hack IEEE double bits (bad)
   */
    if (!(value == value)) {
        str[0] = 'n';
        str[1] = 'a';
        str[2] = 'n';
        str[3] = '\0';
        return (size_t)3;
    }
    /* if input is larger than thres_max, revert to exponential */
    const double thres_max = (double)(0x7FFFFFFF);

    double diff = 0.0;
    char* wstr = str;

    if (prec < 0) {
        prec = 0;
    } else if (prec > 9) {
        /* precision of >= 10 can lead to overflow errors */
        prec = 9;
    }

    /* we'll work in positive values and deal with the
     negative sign issue later */
    int neg = 0;
    if (value < 0) {
        neg = 1;
        value = -value;
    }

    // given 0.05, prec=1
    // whole = 0
    // tmp = (0.05)* 10 = 0.5
    // frac = 0
    // diff = tmp -frac == 0.5 - 0.0 = 0.5
    //
    int whole = (int)value;
    double tmp = (value - whole) * powers_of_10[prec];
    uint32_t frac = (uint32_t)(tmp);
    diff = tmp - frac;

    if (diff > 0.5) {
        ++frac;
        /* handle rollover, e.g.  case 0.99 with prec 1 is 1.0  */
        if (frac >= powers_of_10[prec]) {
            frac = 0;
            ++whole;
        }
    } else if (diff == 0.5 && prec > 0 && (frac & 1)) {
        /* if halfway, round up if odd, OR
       if last digit is 0.  That last part is strange */
        ++frac;
        if (frac >= powers_of_10[prec]) {
            frac = 0;
            ++whole;
        }
    } else if (diff == 0.5 && prec == 0 && (whole & 1)) {
        ++frac;
        if (frac >= powers_of_10[prec]) {
            frac = 0;
            ++whole;
        }
    }

    /* for very large numbers switch back to native sprintf for exponentials.
     anyone want to write code to replace this? */
    /*
     normal printf behavior is to print EVERY whole number digit
     which can be 100s of characters overflowing your buffers == bad
     */
    if (value > thres_max) {
        //sprintf(str, "%e", neg ? -value : value);
        //return strlen(str);
    }

    int count = prec;
    while (count > 0) {
        --count;
        *wstr++ = (char)(48 + (frac % 10));
        frac /= 10;
    }
    if (frac > 0) {
        ++whole;
    }

    /* add decimal */
    if (prec > 0) {
        *wstr++ = '.';
    }

    /* do whole part
   * Take care of sign conversion
   * Number is reversed.
   */
    do
        *wstr++ = (char)(48 + (whole % 10));
    while (whole /= 10);
    if (neg) {
        *wstr++ = '-';
    }
    *wstr = '\0';
    strreverse(str, wstr - 1);
    return (size_t)(wstr - str);
}

__device__ char *ftoaDevice(double value)
{
  static char buf[100];
  modp_dtoa(value, buf, 4);
  return buf;
}




