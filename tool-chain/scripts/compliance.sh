#!/bin/bash
COMPLIANCE_LOG_DIR=$TAIGA_PROJECT_ROOT/logs/verilator/compliance
OUTPUT_DIR=$TAIGA_PROJECT_ROOT/logs/gitlab-runner
mkdir -p $OUTPUT_DIR

#comppliance test
make run-compliance-tests-verilator 
cp -r $COMPLIANCE_LOG_DIR $OUTPUT_DIR/
