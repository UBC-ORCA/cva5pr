#!/bin/bash

ROOT_DIR=$PWD

. $ROOT_DIR/settings.sh

TOOL_CHAIN_DIR=$(ROOT_DIR)/tool-chain

if [ -d "$ROOT_DIR/RISCV-compiler" ]
then 
    echo "Directory RISCV-compiler already exists"
    rm -rf RISCV-compiler
    rm -rf logs/tool-chain
else 
    echo "Creating new RISCV-compiler directory..."
fi

mkdir RISCV-compiler
mkdir riscv32-unknown-elf
mv riscv32-unknown-elf/ RISCV-compiler/
mkdir -p logs/tool-chain

echo "Start building binutils-gdb..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/binutils-gdb.sh > logs/tool-chain/binutils-gdb.log
echo "Done building binutils-gdb..."

echo "Start building first-gcc..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/first-gcc.sh > logs/tool-chain/first-gcc.log
echo "Done building first-gcc..."

echo "Start building newlib..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/newlib.sh > logs/tool-chain/newlib.log
echo "Done building newlib..."

echo "Start building final-gcc..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/final-gcc.sh > logs/tool-chain/final-gcc.log
echo "Done building final-gcc..."

echo "Start building picolibc..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/picolibc.sh > logs/tool-chain/picolibc.log
echo "Done building picolibc..."

echo "Start building verilator..."
export RESULT=OK
. $TOOL_CHAIN_DIR/scripts/verilator.sh > logs/tool-chain/verilator.log
echo "Done building verilator..."
