#!/bin/bash

ROOT_DIR=$PWD

. $ROOT_DIR/setup.sh

if [ -d "$ROOT_DIR/RISCV-compiler" ]
then 
    echo "Directory RISCV-compiler already exists"
    #exit 9999
else 
    echo "Creating new RISCV-compiler directory..."
    mkdir RISCV-compiler
    mkdir riscv32-unknown-elf
    mv riscv32-unknown-elf/ RISCV-compiler/
fi

echo "Installing binutils-gdb..."
cd $ROOT_DIR/binutils-gdb
git checkout binutils-2_34
mkdir build-binutils
cd build-binutils/
CC=gcc ../configure --target=$TARGET --prefix=$PREFIX --disable-sim --disable-gdb --disable-readline --disable-libdecnumber --with-expat=yes
make all -j8
make install -j8
cd ../..

echo "Installing gcc..."
cd $ROOT_DIR/gcc/
git checkout releases/gcc-10
mkdir build-gcc
cd build-gcc/
../configure --target=$TARGET --with-arch=rv32im --with-abi=ilp32 --prefix=$PREFIX --without-headers --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --disable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-multilib --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
make all-gcc -j8
make install-gcc -j8
cd ../..

echo "Installing picolibc..."
cd $ROOT_DIR/picolibc/
mkdir mkdir build-riscv32-unknown-elf
cd build-riscv32-unknown-elf
../do-riscv-configure
ninja
ninja install

echo "Installing gcc..."
cd $ROOT_DIR/gcc/
git checkout releases/gcc-10
mkdir build-gcc
cd build-gcc/
../configure --target=$TARGET --with-arch=rv32im --with-abi=ilp32 --prefix=$PREFIX --without-headers --with-newlib  --with-gnu-as --with-gnu-ld  --disable-shared --disable-threads --disable-tls --enable-languages=c,c++ --with-system-zlib --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-multilib --disable-tm-clone-registry CFLAGS_FOR_TARGET="-O2 -mcmodel=medlow"
make all-gcc -j8
make install-gcc -j8
cd ../..

echo "Installing verilator..."
cd $ROOT_DIR/verilator
git pull
git checkout stable
autoconf
./configure
make
sudo make install