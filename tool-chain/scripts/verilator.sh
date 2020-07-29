#!/bin/bash

cd $TAIGA_PROJECT_ROOT/tool-chain/verilator

autoconf
./configure --prefix=$PREFIX
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building verilator (logfile: verilator.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/verilator.log
    exit 6
fi
make
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building verilator (logfile: verilator.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/verilator.log
    exit 6
fi
make install
if [ $? -ne 0 ]; then
    export RESULT=FAIL
    echo "Building verilator (logfile: verilator.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/verilator.log
    exit 6
fi
cd ../
echo "Building verilator (logfile: verilator.log) - $RESULT" >> $TAIGA_PROJECT_ROOT/logs/tool-chain/verilator.log
