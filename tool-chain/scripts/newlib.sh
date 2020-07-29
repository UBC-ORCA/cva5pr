#!/bin/bash

cd $TAIGA_PROJECT_ROOT/tool-chain/newlib-cygwin

if [ -d "build" ]
then 
    echo "Directory build already exists. Removing..."
    rm -rf build
else 
    echo "Creating new build directory..."
fi
mkdir build
cd build

../configure --target=$TARGET --prefix=$PREFIX  --enable-newlib-io-long-double --enable-newlib-io-long-long --enable-newlib-io-c99-formats CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building newlib (logfile: newlib.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/newlib.log
    exit 3
fi
make all
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building newlib (logfile: newlib.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/newlib.log
    exit 3
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building newlib (logfile: newlib.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/newlib.log
    exit 3
fi
cd ../..
echo "Building newlib (logfile: newlib.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/newlib.log
