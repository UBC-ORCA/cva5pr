#!/bin/bash

cd $PWD/verilator
git pull
git checkout stable
autoconf
./configure
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
fi
cd ../