#!/bin/bash

ROOT_DIR=$PWD

. $ROOT_DIR/setup.sh

if [ -d "$ROOT_DIR/RISCV-compiler" ]
then 
    echo "Directory RISCV-compiler already exists"
    rm -rf RISCV-compiler
    rm -rf logs
else 
    echo "Creating new RISCV-compiler directory..."
fi

mkdir RISCV-compiler
mkdir riscv32-unknown-elf
mv riscv32-unknown-elf/ RISCV-compiler/
mkdir logs

echo "Start building binutils-gdb..."
export RESULT=OK
. $ROOT_DIR/scripts/binutils-gdb.sh > logs/binutils-gdb.log
echo "Done building binutils-gdb..."

echo "Start building first-gcc..."
export RESULT=OK
. $ROOT_DIR/scripts/first-gcc.sh > logs/first-gcc.log
echo "Done building first-gcc..."

echo "Start building newlib..."
export RESULT=OK
. $ROOT_DIR/scripts/newlib.sh > logs/newlib.log
echo "Done building newlib..."

echo "Start building final-gcc..."
export RESULT=OK
. $ROOT_DIR/scripts/final-gcc.sh > logs/final-gcc.log
echo "Done building final-gcc..."

echo "Start building picolibc..."
export RESULT=OK
. $ROOT_DIR/scripts/picolibc.sh > logs/picolibc.log
echo "Done building picolibc..."

echo "Start building verilator..."
export RESULT=OK
. $ROOT_DIR/scripts/verilator.sh > logs/verilator.log
echo "Done building verilator..."
