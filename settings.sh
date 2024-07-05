#!/bin/bash
export TAIGA_PROJECT_ROOT=$PWD
export CVA5_DIR=$PWD/cva5
export ELF_TO_HW_INIT=$CVA5_DIR/tools/elf-to-hw-init.py
export TARGET=riscv32-unknown-elf

export OPT_DIR=$PWD/utils/opt
export PATH=$OPT_DIR:$PATH
mkdir -p $OPT_DIR
