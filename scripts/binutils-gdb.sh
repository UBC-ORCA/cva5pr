#!/bin/bash

cd $PWD/binutils-gdb
git checkout binutils-2_34
mkdir build-binutils
cd build-binutils/
CC=gcc ../configure --target=$TARGET --prefix=$PREFIX --disable-sim --disable-gdb --disable-readline --disable-libdecnumber --with-expat=yes
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
