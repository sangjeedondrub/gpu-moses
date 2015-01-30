BOOST_DIR = boost
DALM_DIR = $(PWD)/DALM
KENLM_DIR = $(PWD)/kenlm

CXX = nvcc #g++ #clang++
CPPFLAGS =  -arch=sm_30 -O3 -I. -I$(BOOST_DIR)/include \
	-I$(DALM_DIR)/include -I$(DALM_DIR)/darts-clone -I$(DALM_DIR)/MurmurHash3 -I$(KENLM_DIR) \
	-DSCORE_BREAKDOWN  
#-DKENLM_MAX_ORDER=7 -DUSE_KENLM 

LIBS = -L$(DALM_DIR)/lib -L$(KENLM_DIR)/lib  \
	-lz -llzma -lbz2 -lrt -lpthread \
	#-lkenlm  -liconv #-lrt # 

OBJECTS = System.o		Phrase.o		Timer.o		Word.o \
	InputFileStream.o	Scores.o		TypeDef.o		WordsBitmap.o \
	InputPath.o		Sentence.o		Util.o		WordsRange.o \
	TargetPhrase.o	MyVocab.o \
  TargetPhrases.o	Weights.o \
	PhraseVec.o \
	FF/PhrasePenalty.o		FF/WordPenaltyProducer.o \
	FF/StatefulFeatureFunction.o \
	FF/FeatureFunction.o		FF/StatelessFeatureFunction.o \
	FF/TranslationModel/PhraseTable.o		FF/TranslationModel/UnknownWordPenalty.o \
	FF/TranslationModel/PhraseTableMemory.o \
	FF/TranslationModel/Memory/Node.o \
	Search/Manager.o util/exception.o \
	CUDA/CUDA.cu


OBJECTS_fast_moses = $(OBJECTS) Main.o

all: fast-moses

fast-moses: $(OBJECTS_fast_moses)
	$(CXX) $(CPPFLAGS) -o fast-moses $(OBJECTS_fast_moses) $(LIBS)
#rm -f *.o */*.o */*/*.o */*/*/*.o


clean:
	rm -f fast-moses *.o */*.o */*/*.o */*/*/*.o

