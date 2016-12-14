BOOST_DIR = boost

CC = gcc
CCFLAGS = -O3 -I. -I$(BOOST_DIR)/include

CXX = g++ #clang++
CXXFLAGS = -std=c++11 -O3 -I. -I$(BOOST_DIR)/include
#-DKENLM_MAX_ORDER=7 -DUSE_KENLM 

NVCC = nvcc
NVCCFLAGS = -std=c++11 -arch=sm_50 -rdc=true  -O3 -I. -I$(BOOST_DIR)/include

LIBS = -L$(DALM_DIR)/lib -L$(KENLM_DIR)/lib  \
	-lz -llzma -lbz2 -lrt -lpthread \
	-lboost_program_options -lboost_system
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
		Scores.o ScoresUnmanaged.o Stack.o Stacks.o \
		TargetPhrase.o TargetPhrases.o Test.o \
		CUDA/Managed.o CUDA/Util.o \
		FF/Distortion.o FF/FeatureFunctions.o FF/StatefulFeatureFunction.o \
		TranslationModel/PhraseTableMemory.o \
		util/bit_packing.cc                                 util/read_compressed.cc \
		util/mmap.cc                                \
		util/scoped.cc \
		util/ersatz_progress.cc         util/murmur_hash.cc                         \
		util/exception.cc               util/parallel_read.cc                       \
		util/file.cc                                           util/string_piece.cc \
		util/file_piece.cc              util/pool.cc                                \
		util/float_to_string.cc          \
		util/integer_to_string.cc       util/random.cc                              \
		util/usage.cc \
		util/double-conversion/bignum.cc       util/double-conversion/cached-powers.cc \
		util/double-conversion/double-conversion.cc  util/double-conversion/fixed-dtoa.cc \
		util/double-conversion/bignum-dtoa.cc  util/double-conversion/diy-fp.cc         \
		util/double-conversion/fast-dtoa.cc          util/double-conversion/strtod.cc


# util/joint_sort_test.cc util/bit_packing_test.cc util/sized_iterator_test.cc util/pcqueue_test.cc util/string_stream_test.cc
# util/file_piece_test.cc util/tempfile_test.cc util/probing_hash_table_test.cc            util/tokenize_piece_test.cc
# util/tokenize_test.cc util/integer_to_string_test.cc  util/random_test.cc util/read_compressed_test.cc
# util/multi_intersection_test.cc util/sorted_uniform_test.cc util/cat_compressed_main.cc
# util/probing_hash_table_benchmark_main.cc

OBJECTS_fast_moses = $(OBJECTS)

all: fast-moses

fast-moses: $(OBJECTS_fast_moses)
	$(NVCC) $(NVCCFLAGS) -o fast-moses $(OBJECTS_fast_moses) $(LIBS)

clean:
	rm -f fast-moses *.o */*.o */*/*.o */*/*/*.o

