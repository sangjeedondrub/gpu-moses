/*
 * Lock.h
 *
 *  Created on: 8 Dec 2016
 *      Author: hieu
 */
#pragma once
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<math_functions.h>
#include<time.h>
#include<cuda.h>
#include<cuda_runtime.h>

class Lock
{
public:
  int *mutex;

  Lock(void){
    int state = 0;
    cudaMalloc((void**) &mutex, sizeof(int));
    cudaMemcpy(mutex, &state, sizeof(int), cudaMemcpyHostToDevice);
  }
  ~Lock(void){
    cudaFree(mutex);
  }
  __device__ void lock(void){
    while(atomicCAS(mutex, 0, 1) != 0);
  }
  __device__ void unlock(void){
    atomicExch(mutex, 0);
  }

};



