#!/bin/bash
OUTPUT_DIR=$TAIGA_PROJECT_ROOT/logs/gitlab-runner/dhrystone
mkdir -p $OUTPUT_DIR

#dhrystone test
make run-dhrystone-verilator
echo "DHRYSTONE TEST RESULT"
#cat $TAIGA_PROJECT_ROOT/logs/verilator/dhrystone.log  
cp $TAIGA_PROJECT_ROOT/logs/verilator/dhrystone.log $OUTPUT_DIR  
