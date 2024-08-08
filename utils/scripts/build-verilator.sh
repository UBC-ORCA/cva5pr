#!/usr/bin/env bash

unset VERILATOR_ROOT

pushd $TAIGA_PROJECT_ROOT/utils/verilator

git pull
git checkout v5.004

autoconf

./configure --prefix=$OPT_DIR/verilator
if [ $? -ne 0 ]; then
	echo "issue with configuring verilator"
    exit 1
fi

make
if [ $? -ne 0 ]; then
	echo "issue with building verilator"
    exit 1
fi

sudo make install
if [ $? -ne 0 ]; then
	echo "issue with installing verilator"
    exit 1
fi

popd
