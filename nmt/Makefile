BOOST_DIR = boost

CC = gcc
CCFLAGS = -O3 -I. -I$(BOOST_DIR)/include

CXX = g++ #clang++
CXXFLAGS = -std=c++11 -O3 -I. -I$(BOOST_DIR)/include -I../xmlrpc-c/include
#CXXFLAGS = -std=c++11 -I. -I$(BOOST_DIR)/include -lprofiler -Og
#-DKENLM_MAX_ORDER=7 -DUSE_KENLM 

NVCC = nvcc
NVCCFLAGS = -std=c++11 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60  -rdc=true  -O3 -I. -I$(BOOST_DIR)/include -I../xmlrpc-c/include
#NVCCFLAGS = -std=c++11 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60  -rdc=true   -I. -I$(BOOST_DIR)/include  -lprofiler -O0

LIBS = -L$(DALM_DIR)/lib -L$(KENLM_DIR)/lib  \
	-lz -llzma -lbz2 -lrt -lpthread \
	-lboost_program_options -lboost_system 
	#-lprofiler -ltcmalloc_and_profiler
        #-lkenlm  -liconv #-lrt # 

.SUFFIXES: .c .cpp .cu .o

%.o: %.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CCFLAGS) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@

OBJECTS = Main.o God.o EncoderDecoder.o

OBJECTS_nmt = $(OBJECTS)

all: nmt

nmt: $(OBJECTS_nmt)
	$(NVCC) $(NVCCFLAGS) -o nmt $(OBJECTS_nmt) $(LIBS)

clean:
	rm -f gpu-moses *.o */*.o */*/*.o */*/*/*.o

