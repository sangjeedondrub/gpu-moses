################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../FF/FeatureFunction.o \
../FF/PhrasePenalty.o \
../FF/StatefulFeatureFunction.o \
../FF/StatelessFeatureFunction.o \
../FF/WordPenaltyProducer.o 

CPP_SRCS += \
../FF/FFState.cpp \
../FF/FeatureFunction.cpp \
../FF/PhrasePenalty.cpp \
../FF/StatefulFeatureFunction.cpp \
../FF/StatelessFeatureFunction.cpp \
../FF/WordPenaltyProducer.cpp 

OBJS += \
./FF/FFState.o \
./FF/FeatureFunction.o \
./FF/PhrasePenalty.o \
./FF/StatefulFeatureFunction.o \
./FF/StatelessFeatureFunction.o \
./FF/WordPenaltyProducer.o 

CPP_DEPS += \
./FF/FFState.d \
./FF/FeatureFunction.d \
./FF/PhrasePenalty.d \
./FF/StatefulFeatureFunction.d \
./FF/StatelessFeatureFunction.d \
./FF/WordPenaltyProducer.d 


# Each subdirectory must supply rules for building sources it contributes
FF/%.o: ../FF/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "FF" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


