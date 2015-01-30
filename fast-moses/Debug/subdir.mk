################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../InputFileStream.o \
../InputPath.o \
../Main.o \
../MyVocab.o \
../Phrase.o \
../PhraseVec.o \
../Scores.o \
../Sentence.o \
../System.o \
../TargetPhrase.o \
../TargetPhrases.o \
../Timer.o \
../TypeDef.o \
../Util.o \
../Weights.o \
../Word.o \
../WordsBitmap.o \
../WordsRange.o 

CPP_SRCS += \
../InputFileStream.cpp \
../InputPath.cpp \
../Main.cpp \
../MyVocab.cpp \
../Phrase.cpp \
../PhraseVec.cpp \
../Scores.cpp \
../Sentence.cpp \
../System.cpp \
../TargetPhrase.cpp \
../TargetPhrases.cpp \
../Timer.cpp \
../TypeDef.cpp \
../Util.cpp \
../Weights.cpp \
../Word.cpp \
../WordsBitmap.cpp \
../WordsRange.cpp 

OBJS += \
./InputFileStream.o \
./InputPath.o \
./Main.o \
./MyVocab.o \
./Phrase.o \
./PhraseVec.o \
./Scores.o \
./Sentence.o \
./System.o \
./TargetPhrase.o \
./TargetPhrases.o \
./Timer.o \
./TypeDef.o \
./Util.o \
./Weights.o \
./Word.o \
./WordsBitmap.o \
./WordsRange.o 

CPP_DEPS += \
./InputFileStream.d \
./InputPath.d \
./Main.d \
./MyVocab.d \
./Phrase.d \
./PhraseVec.d \
./Scores.d \
./Sentence.d \
./System.d \
./TargetPhrase.d \
./TargetPhrases.d \
./Timer.d \
./TypeDef.d \
./Util.d \
./Weights.d \
./Word.d \
./WordsBitmap.d \
./WordsRange.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


