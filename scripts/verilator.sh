#!/bin/bash

cd $PWD/verilator
autoconf
./configure --prefix=$PREFIX
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building verilator (logfile: verilator.log) - $RESULT" >> ../logs/build.log
    exit 6
fi
make
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building verilator (logfile: verilator.log) - $RESULT" >> ../logs/build.log
    exit 6
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building verilator (logfile: verilator.log) - $RESULT" >> ../logs/build.log
    exit 6
fi
cd ../
echo "Building verilator (logfile: verilator.log) - $RESULT" >> logs/build.log
