#!/bin/bash

cd $PWD/picolibc/
mkdir mkdir build-riscv32-unknown-elf
cd build-riscv32-unknown-elf
../do-riscv-configure
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
ninja
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
ninja install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
cd ../..