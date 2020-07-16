#!/bin/bash

cd $PWD/gcc/
git checkout releases/gcc-10
if [ -d "$PWD/build-gcc" ]
then 
    echo "Directory build-gcc already exists. Removing..."
    rm -rf build-gcc
else 
    echo "Creating new build-gcc directory..."
fi
mkdir build-gcc
cd build-gcc/
../configure --target=$TARGET --with-arch=rv32im --with-abi=ilp32 --prefix=$PREFIX --without-headers --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --disable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-multilib --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building first-gcc (logfile: first-gcc.log) - $RESULT" >> ../../logs/build.log
    exit 2
fi
make all-gcc
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building first-gcc (logfile: first-gcc.log) - $RESULT" >> ../../logs/build.log
    exit 2    
fi
make install-gcc
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building first-gcc (logfile: first-gcc.log) - $RESULT" >> ../../logs/build.log
    exit 2    
fi
cd ../..
echo "Building first-gcc (logfile: first-gcc.log) - $RESULT" >> logs/build.log
