#!/bin/bash

cd $TAIGA_PROJECT_ROOT/tool-chain/picolibc

if [ -d "riscv32-unknown-elf-taiga" ]
then 
    echo "Directory riscv32-unknown-elf-taiga already exists. Removing..."
    rm -rf riscv32-unknown-elf-taiga
else 
    echo "Creating new build directory..."
fi
mkdir riscv32-unknown-elf-taiga
cd riscv32-unknown-elf-taiga

../scripts/do-riscv-taiga-configure --prefix=$PREFIX --buildtype=debugoptimized
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/picolibc.log
    exit 5
fi
ninja
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/picolibc.log
    exit 5
fi
ninja install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/picolibc.log
    exit 5
fi
cd ../..
echo "Building picolibc (logfile: picolibc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/picolibc.log
