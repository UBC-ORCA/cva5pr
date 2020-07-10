#!/bin/bash

cd $PWD/gcc/
git checkout releases/gcc-10
mkdir build-gcc
cd build-gcc/
../configure --target=$TARGET --prefix=$PREFIX --without-headers --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --disable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --enable-multilib --with-multilib-list=ilp32 --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make all-gcc
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make install-gcc
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
cd ../..
