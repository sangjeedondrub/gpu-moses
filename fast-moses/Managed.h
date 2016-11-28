#pragma once
#include <cuda.h>

class Managed
{
public:
	void *operator new(size_t len) {
		//cerr << "new object" << endl;
		void *ptr;
		cudaMallocManaged(&ptr, len);
		return ptr;
	}

	void operator delete(void *ptr) {
		 cudaFree(ptr);
	}
};

