################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../Search/Manager.o 

CPP_SRCS += \
../Search/Manager.cpp \
../Search/SquareMatrix.cpp 

OBJS += \
./Search/Manager.o \
./Search/SquareMatrix.o 

CPP_DEPS += \
./Search/Manager.d \
./Search/SquareMatrix.d 


# Each subdirectory must supply rules for building sources it contributes
Search/%.o: ../Search/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "Search" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-6.0/bin/nvcc -DSCORE_BREAKDOWN -I"/mnt/thor7/hieu/workspace/private/ultra-moses/fast-moses" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


