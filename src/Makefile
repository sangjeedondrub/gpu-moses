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

OBJECTS = InputFileStream.o MyVocab.o TypeDef.o \
		Util.o \
		Bitmap.o Hypothesis.o  InputPath.o \
		Main.o Manager.o Parameter.o Phrase.o Range.o \
		Scores.o ScoresUnmanaged.o Stack.o Stacks.o System.o \
		TargetPhrase.o TargetPhrases.o Test.o \
		CUDA/Managed.o CUDA/Util.o \
		FF/Distortion.o FF/FeatureFunction.o FF/FeatureFunctions.o FF/StatefulFeatureFunction.o FF/WordPenalty.o \
		FF/UnknownWordPenalty.o \
		LM/LanguageModel.o \
		TranslationModel/PhraseTableMemory.o \
		util/bit_packing.o     	util/read_compressed.o \
		util/mmap.o                                \
		util/scoped.o \
		util/ersatz_progress.o  util/murmur_hash.o                         \
		util/exception.o        util/parallel_read.o                       \
		util/file.o             util/string_piece.o \
		util/file_piece.o       util/pool.o                                \
		util/float_to_string.o          \
		util/integer_to_string.o	util/random.o                              \
		util/usage.o \
		util/double-conversion/bignum.o       util/double-conversion/cached-powers.o \
		util/double-conversion/double-conversion.o  util/double-conversion/fixed-dtoa.o \
		util/double-conversion/bignum-dtoa.o  util/double-conversion/diy-fp.o         \
		util/double-conversion/fast-dtoa.o          util/double-conversion/strtod.o \
		parameters/AllOptions.o 	parameters/BookkeepingOptions.o 	parameters/ContextParameters.o \
		parameters/CubePruningOptions.o 	parameters/InputOptions.o 	parameters/LMBR_Options.o \
		parameters/MBR_Options.o	parameters/NBestOptions.o parameters/OOVHandlingOptions.o \
		parameters/OptionsBaseClass.o	parameters/ReorderingOptions.o	parameters/ReportingOptions.o \
		parameters/SearchOptions.o	#parameters/ServerOptions.cpp parameters/SyntaxOptions.cpp	

# util/joint_sort_test.cc util/bit_packing_test.cc util/sized_iterator_test.cc util/pcqueue_test.cc util/string_stream_test.cc
# util/file_piece_test.cc util/tempfile_test.cc util/probing_hash_table_test.cc            util/tokenize_piece_test.cc
# util/tokenize_test.cc util/integer_to_string_test.cc  util/random_test.cc util/read_compressed_test.cc
# util/multi_intersection_test.cc util/sorted_uniform_test.cc util/cat_compressed_main.cc
# util/probing_hash_table_benchmark_main.cc

OBJECTS_gpu_moses = $(OBJECTS)

all: gpu-moses

gpu-moses: $(OBJECTS_gpu_moses)
	$(NVCC) $(NVCCFLAGS) -o gpu-moses $(OBJECTS_gpu_moses) $(LIBS)

clean:
	rm -f gpu-moses *.o */*.o */*/*.o */*/*/*.o

