BOOST_DIR = boost

CXX = g++ #clang++
CXXFLAGS = -std=c++11 -O3 -I. -I$(BOOST_DIR)/include
#-DKENLM_MAX_ORDER=7 -DUSE_KENLM 

NVCC = nvcc
NVCCFLAGS = -std=c++11 -arch=sm_50 -rdc=true  -O3 -I. -I$(BOOST_DIR)/include

LIBS = -L$(DALM_DIR)/lib -L$(KENLM_DIR)/lib  \
	-lz -llzma -lbz2 -lrt -lpthread \
	#-lkenlm  -liconv #-lrt # 

.SUFFIXES: .c .cpp .cu .o

%.o: %.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

OBJECTS = InputFileStream.o MyVocab.o TypeDef.o \
		Util.o \
		Bitmap.o Hypothesis.o  InputPath.o InputPaths.o \
		Main.o Managed.o Manager.o Phrase.o PhraseTableMemory.o Range.o \
		Scores.o Stack.o Stacks.o \
		TargetPhrase.o TargetPhrases.o Test.o 


OBJECTS_fast_moses = $(OBJECTS)

all: fast-moses

fast-moses: $(OBJECTS_fast_moses)
	$(NVCC) $(NVCCFLAGS) -o fast-moses $(OBJECTS_fast_moses) $(LIBS)

clean:
	rm -f fast-moses *.o */*.o */*/*.o */*/*/*.o

