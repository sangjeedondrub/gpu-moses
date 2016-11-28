#pragma once
#include <iostream>
#include <cuda.h>

class Managed
{
public:
	void *operator new(size_t len) {
		std::cerr << "new object" << std::endl;
		void *ptr;
		cudaMallocManaged(&ptr, len);
		return ptr;
	}

	void operator delete(void *ptr) {
		std::cerr << "delete object" << std::endl;
		 cudaFree(ptr);
	}
};

