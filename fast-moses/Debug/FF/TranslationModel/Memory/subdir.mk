################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../FF/TranslationModel/Memory/Node.o 

CPP_SRCS += \
../FF/TranslationModel/Memory/Node.cpp 

OBJS += \
./FF/TranslationModel/Memory/Node.o 

CPP_DEPS += \
./FF/TranslationModel/Memory/Node.d 


# Each subdirectory must supply rules for building sources it contributes
FF/TranslationModel/Memory/%.o: ../FF/TranslationModel/Memory/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "FF/TranslationModel/Memory" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


