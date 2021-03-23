#!/bin/bash
#argv[1] = number of config tests to run;
config_max=$1
EMBENCH_LOG_DIR=$TAIGA_PROJECT_ROOT/logs/verilator/embench
OUTPUT_DIR=$TAIGA_PROJECT_ROOT/logs/gitlab-runner/embench
mkdir -p $OUTPUT_DIR

#build embench
make build-embench

#backup original taiga_config.sv
cp $TAIGA_DIR/core/taiga_config.sv $TAIGA_DIR/core/taiga_config.sv.bak

#run embench with different configs
for ((i = 0; i < config_max; i++))
do 
	# make clean
	python3 $TAIGA_DIR/tools/taiga_config_mod.py $TAIGA_DIR/core/taiga_config.sv
	make run-embench-verilator
	mkdir -p $OUTPUT_DIR/config_$i
	cp $TAIGA_DIR/core/taiga_config.sv $OUTPUT_DIR/config_$i
	cp $EMBENCH_LOG_DIR/../embench.log $OUTPUT_DIR/config_$i
	python3 $TAIGA_DIR/tools/verilator_graphs.py > $OUTPUT_DIR/config_$i/config_"$i"_table.log
done

