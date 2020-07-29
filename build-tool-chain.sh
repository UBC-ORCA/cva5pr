#!/bin/bash

ROOT_DIR=$PWD

. $ROOT_DIR/settings.sh

TOOL_CHAIN_DIR=$ROOT_DIR/tool-chain

if [ -d "$ROOT_DIR/tool-chain/RISCV-compiler" ]
then 
    echo "Directory RISCV-compiler already exists"
    rm -rf RISCV-compiler
    rm -rf logs/tool-chain
else 
    echo "Creating new RISCV-compiler directory..."
fi

mkdir -p tool-chain/RISCV-compiler/riscv32-unknown-elf
mkdir -p logs/tool-chain

echo "Start building binutils-gdb..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/binutils-gdb.sh > logs/tool-chain/binutils-gdb.log
echo "Done building binutils-gdb..."

cd $ROOT_DIR
echo "Start building first-gcc..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/first-gcc.sh > logs/tool-chain/first-gcc.log
echo "Done building first-gcc..."

cd $ROOT_DIR
echo "Start building newlib..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/newlib.sh > logs/tool-chain/newlib.log
echo "Done building newlib..."

cd $ROOT_DIR
echo "Start building final-gcc..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/final-gcc.sh > logs/tool-chain/final-gcc.log
echo "Done building final-gcc..."

cd $ROOT_DIR
echo "Start building picolibc..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/picolibc.sh > logs/tool-chain/picolibc.log
echo "Done building picolibc..."

cd $ROOT_DIR
echo "Start building verilator..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/verilator.sh > logs/tool-chain/verilator.log
echo "Done building verilator..."
