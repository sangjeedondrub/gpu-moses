################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../FF/TranslationModel/PhraseTable.o \
../FF/TranslationModel/PhraseTableMemory.o \
../FF/TranslationModel/UnknownWordPenalty.o 

CPP_SRCS += \
../FF/TranslationModel/PhraseTable.cpp \
../FF/TranslationModel/PhraseTableMemory.cpp \
../FF/TranslationModel/UnknownWordPenalty.cpp 

OBJS += \
./FF/TranslationModel/PhraseTable.o \
./FF/TranslationModel/PhraseTableMemory.o \
./FF/TranslationModel/UnknownWordPenalty.o 

CPP_DEPS += \
./FF/TranslationModel/PhraseTable.d \
./FF/TranslationModel/PhraseTableMemory.d \
./FF/TranslationModel/UnknownWordPenalty.d 


# Each subdirectory must supply rules for building sources it contributes
FF/TranslationModel/%.o: ../FF/TranslationModel/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "FF/TranslationModel" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


