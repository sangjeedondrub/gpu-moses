################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../util/exception.o 

CC_SRCS += \
../util/exception.cc 

OBJS += \
./util/exception.o 

CC_DEPS += \
./util/exception.d 


# Each subdirectory must supply rules for building sources it contributes
util/%.o: ../util/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "util" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


