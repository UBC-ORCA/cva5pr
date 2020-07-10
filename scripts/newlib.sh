#!/bin/bash

cd $PWD/newlib-cygwin/
mkdir build-newlib
cd build-newlib/
../configure --target=$TARGET --prefix=$PREFIX  --enable-newlib-io-long-double --enable-newlib-io-long-long --enable-newlib-io-c99-formats CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make all
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
cd ../..
