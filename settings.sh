#!/bin/bash
export TAIGA_PROJECT_ROOT=$PWD
export CVA5_DIR=$PWD/cva5
export ELF_TO_HW_INIT=$CVA5_DIR/tools/elf-to-hw-init.py
export TARGET=riscv32-unknown-elf
export PREFIX=$PWD/tool-chain/RISCV-compiler/$TARGET
export PATH=$PATH:$PREFIX/bin
