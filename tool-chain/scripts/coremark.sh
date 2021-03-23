#!/bin/bash
OUTPUT_DIR=$TAIGA_PROJECT_ROOT/logs/gitlab-runner/coremark
mkdir -p $OUTPUT_DIR

#coremark test
make run-coremark-verilator
cp $TAIGA_PROJECT_ROOT/logs/verilator/coremark.log $OUTPUT_DIR/ 
