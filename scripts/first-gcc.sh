#!/bin/bash

cd $PWD/gcc/
git checkout releases/gcc-10
mkdir build-gcc
cd build-gcc/
../configure --target=$TARGET --with-arch=rv32ima --with-abi=ilp32 --prefix=$PREFIX --without-headers --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --disable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --with-multilib-list=rv32i-rv32im-rv32ima --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make all-gcc -j$1
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make install-gcc -j$1
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
cd ../..