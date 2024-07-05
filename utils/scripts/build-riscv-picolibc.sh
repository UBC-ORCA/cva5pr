#!/usr/bin/env bash

pushd $TAIGA_PROJECT_ROOT/utils/picolibc

if [ -d riscv32-unknown-elf-taiga ]; then
    rm -rf riscv32-unknown-elf-taiga/
fi

mkdir riscv32-unknown-elf-taiga
pushd riscv32-unknown-elf-taiga

../scripts/do-riscv-taiga-configure --prefix=$OPT_DIR/picolibc --buildtype=debugoptimized

if [ $? -ne 0 ]; then
	echo "issue with configuring picolibc"
    exit 1
fi

ninja

if [ $? -ne 0 ]; then
	echo "issue with building picolibc"
    exit 1
fi

sudo ninja install

if [ $? -ne 0 ]; then
	echo "issue with installing picolibc"
    exit 1
fi

popd

popd
