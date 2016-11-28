BOOST_DIR = boost

CXX = nvcc #g++ #clang++
CPPFLAGS =  -arch=sm_30 -O3 -I. -I$(BOOST_DIR)/include
#-DKENLM_MAX_ORDER=7 -DUSE_KENLM 

LIBS = -L$(DALM_DIR)/lib -L$(KENLM_DIR)/lib  \
	-lz -llzma -lbz2 -lrt -lpthread \
	#-lkenlm  -liconv #-lrt # 

OBJECTS = InputFileStream.o MyVocab.o TypeDef.o \
		Util.o \
		Main.cu PhraseTableMemory.cu Scores.cu TargetPhrase.cu TargetPhrases.cu Test.cu 


OBJECTS_fast_moses = $(OBJECTS)

all: fast-moses

fast-moses: $(OBJECTS_fast_moses)
	$(CXX) $(CPPFLAGS) -o fast-moses $(OBJECTS_fast_moses) $(LIBS)
#rm -f *.o */*.o */*/*.o */*/*/*.o


clean:
	rm -f fast-moses *.o */*.o */*/*.o */*/*/*.o

