#!/bin/bash

cd $PWD/gcc/
rm -rf build-gcc
mkdir build-gcc
cd build-gcc
../configure --target=$TARGET --prefix=$PREFIX --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --enable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --with-multilib-list=ilp32 --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" > ../../logs/build.log
    exit 4
fi
make all
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" > ../../logs/build.log
    exit 4
fi
make install 
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" > ../../logs/build.log
    exit 4
fi
cd ../..
echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" > logs/build.log