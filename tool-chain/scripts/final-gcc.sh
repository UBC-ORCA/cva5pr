#!/bin/bash

cd $TAIGA_PROJECT_ROOT/tool-chain/gcc

if [ -d "build" ]
then 
    echo "Directory build already exists. Removing..."
    rm -rf build
else 
    echo "Creating new build directory..."
fi
mkdir build
cd build

../configure --target=$TARGET --with-arch=rv32im --with-abi=ilp32 --prefix=$PREFIX --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --enable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-multilib --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/final-gcc.log
    exit 4
fi
make all
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/final-gcc.log
    exit 4
fi
make install 
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/final-gcc.log
    exit 4
fi
cd ../..
echo "Building final-gcc (logfile: final-gcc.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/final-gcc.log
