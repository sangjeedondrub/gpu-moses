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
