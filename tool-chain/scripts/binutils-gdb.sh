#!/bin/bash

cd $PWD/tool-chain/binutils-gdb

if [ -d "$PWD/tool-chain/build-binutils" ]
then 
    echo "Directory build-binutils already exists. Removing..."
    rm -rf build-binutils
else 
    echo "Creating new build-binutils directory..."
fi
mkdir build-binutils
cd build-binutils/
CC=gcc ../configure --target=$TARGET --prefix=$PREFIX --disable-sim --disable-gdb --disable-readline --disable-libdecnumber --with-expat=yes
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building binutils-gdb (logfile: binutils-gdb.log) - $RESULT" >> logs/build/binutils-gdb.log
    exit 1
fi
make all
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building binutils-gdb (logfile: binutils-gdb.log) - $RESULT" >> logs/build/binutils-gdb.log
    exit 1
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building binutils-gdb (logfile: binutils-gdb.log) - $RESULT" >> logs/build/binutils-gdb.log
    exit 1
fi
cd ../..
echo "Building binutils-gdb (logfile: binutils-gdb.log) - $RESULT" >> logs/build/binutils-gdb.log
