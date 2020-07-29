#!/bin/bash
cd $PWD/tool-chain/picolibc/

if [ -d "$PWD/tool-chain/build-riscv32-unknown-elf" ]
then 
    echo "Directory build-riscv32-unknown-elf already exists. Removing..."
    rm -rf build-riscv32-unknown-elf
else 
    echo "Creating new build-riscv32-unknown-elf directory..."
fi
mkdir build-riscv32-unknown-elf
cd build-riscv32-unknown-elf
../do-riscv-configure --prefix=$PREFIX --buildtype=debugoptimized
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> logs/build/picolibc.log
    exit 5
fi
ninja
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> logs/build/picolibc.log
    exit 5
fi
ninja install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> logs/build/picolibc.log
    exit 5
fi
cd ../..
echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> logs/build/picolibc.log