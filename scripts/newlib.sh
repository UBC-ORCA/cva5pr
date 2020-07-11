#!/bin/bash

cd $PWD/newlib-cygwin/
if [ -d "$PWD/build-newlib" ]
then 
    echo "Directory build-newlib already exists. Removing..."
    rm -rf build-newlib
else 
    echo "Creating new build-newlib directory..."
fi
mkdir build-newlib
cd build-newlib/
../configure --target=$TARGET --prefix=$PREFIX  --enable-newlib-io-long-double --enable-newlib-io-long-long --enable-newlib-io-c99-formats CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building newlib (logfile: newlib.log) - $RESULT" > ../../logs/build.log
    exit 3
fi
make all
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building newlib (logfile: newlib.log) - $RESULT" > ../../logs/build.log
    exit 3
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building newlib (logfile: newlib.log) - $RESULT" > ../../logs/build.log
    exit 3
fi
cd ../..
echo "Building newlib (logfile: newlib.log) - $RESULT" > logs/build.log