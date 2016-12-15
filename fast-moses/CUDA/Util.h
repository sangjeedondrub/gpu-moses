#pragma once


__device__ char *itoaDevice(int i);
__device__ size_t strlenDevice(const char *str);

__device__ char *ftoaDevice(double value);

__device__
size_t strlenDevice(const char *str);

__device__ void MemCpy(char *dest, const char *src, size_t count);
__device__ void StrCpy(char *dest, const char *src);

