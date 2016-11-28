BOOST_DIR = boost

CXX = nvcc #g++ #clang++
CPPFLAGS = -std=c++11 -arch=sm_50 -rdc=true  -O3 -I. -I$(BOOST_DIR)/include
#-DKENLM_MAX_ORDER=7 -DUSE_KENLM 

LIBS = -L$(DALM_DIR)/lib -L$(KENLM_DIR)/lib  \
	-lz -llzma -lbz2 -lrt -lpthread \
	#-lkenlm  -liconv #-lrt # 

OBJECTS = InputFileStream.o MyVocab.o TypeDef.o \
		Util.o \
		Bitmap.cu Hypothesis.cu  InputPath.cu InputPaths.cu \
		Main.cu Managed.cu Manager.cu Phrase.cu PhraseTableMemory.cu Range.cu \
		Scores.cu Stack.cu Stacks.cu \
		TargetPhrase.cu TargetPhrases.cu Test.cu 


OBJECTS_fast_moses = $(OBJECTS)

all: fast-moses

fast-moses: $(OBJECTS_fast_moses)
	$(CXX) $(CPPFLAGS) -o fast-moses $(OBJECTS_fast_moses) $(LIBS)
#rm -f *.o */*.o */*/*.o */*/*/*.o


clean:
	rm -f fast-moses *.o */*.o */*/*.o */*/*/*.o

