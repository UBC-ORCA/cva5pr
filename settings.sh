#!/bin/bash
export TAIGA_PROJECT_ROOT=$PWD
export TAIGA_DIR=$PWD/taiga-dev
export TARGET=riscv32-unknown-elf
export PREFIX=$PWD/tool-chain/RISCV-compiler/$TARGET
export PATH=$PATH:$PREFIX/bin
