#!/bin/bash

cd $TAIGA_PROJECT_ROOT/tool-chain/picolibc

if [ -d "build" ]
then 
    echo "Directory build already exists. Removing..."
    rm -rf build
else 
    echo "Creating new build directory..."
fi
mkdir build
cd build

../do-riscv-taiga-configure --prefix=$PREFIX --buildtype=debugoptimized
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
