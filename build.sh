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

echo "Installing binutils-gdb"
echo "Installing GCC"
