#python script creats ram init files for simulation and hardware
###############################################################
RISCV_PREFIX ?= riscv32-unknown-elf-
ELF_TO_HW_INIT_OPTIONS ?= $(RISCV_PREFIX) 0x80000000 2097152
###############################################################

###############################################################
#Verilator Parameters
TRACE_ENABLE = True
VERILATOR_TRACE_FILE = $(TAIGA_PROJECT_ROOT)/logs/sim-trace/verilator_trace.vcd


###############################################################
#CVA5 core makefile
-include $(CVA5_DIR)/tools/cva5.mak
###############################################################


###############################################################
#Embench
#Assumes binaries are in the BENCHMARK_DIR
EMBENCH_DIR=embench
EMBENCH_TRACE_DIR=$(TAIGA_PROJECT_ROOT)/logs/sim-trace
EMBENCH_LOG_DIR=$(TAIGA_PROJECT_ROOT)/logs/verilator/embench
EMBENCH_BENCHMARKS =  \
crc32 \
rgb2luma

#add file path to benchmarks
embench_bins = $(addprefix $(EMBENCH_DIR)/build/bin/, $(EMBENCH_BENCHMARKS))
embench_hw_init = $(addprefix $(EMBENCH_DIR)/build/bin/, $(addsuffix .hw_init, $(EMBENCH_BENCHMARKS)))
embench_logs = $(addprefix $(EMBENCH_LOG_DIR)/, $(addsuffix .log, $(EMBENCH_BENCHMARKS)))

#embench benchmarks copied into a bin folder to simplify makefile rules
.PHONY: build-embench
build-embench :
	cd $(EMBENCH_DIR);\
	./build_all.py -v --clean --builddir=build --warmup-heat=100 --arch=riscv32 --chip=generic --board=cva5-picolibc --cflags="--specs=picolibc.specs --crt0=hosted -march=rv32imav -mabi=ilp32 -mcmodel=medlow -O2 -fno-tree-vectorize -ffunction-sections" --ldflags="--specs=picolibc.specs --crt0=hosted -Xlinker --defsym=__mem_size=2097152 -Wl,--print-memory-usage" --cc-input-pattern="-c {0}" --user-libs="-lm"
	mkdir -p $(EMBENCH_DIR)/build/bin
	$(foreach x,$(EMBENCH_BENCHMARKS), mv $(EMBENCH_DIR)/build/src/$(x)/$(x) $(EMBENCH_DIR)/build/bin/$(x);)
	
#Benchmarks built by build_embench
.PHONY : $(embench_bins)

#Create hw_init files for benchmarks 
$(embench_hw_init) : %.hw_init : %
	python3 $(ELF_TO_HW_INIT) $(ELF_TO_HW_INIT_OPTIONS) $< $@ $<.sim_init

#Run verilator
$(EMBENCH_LOG_DIR)/%.log : $(EMBENCH_DIR)/build/bin/%.hw_init $(CVA5_SIM)
	mkdir -p $(EMBENCH_LOG_DIR)
	mkdir -p $(EMBENCH_TRACE_DIR)
	@echo $< > $@
	$(CVA5_SIM) \
	  "/dev/null"\
	  "/dev/null"\
	  $<\
	  $(VERILATOR_TRACE_FILE)\
	  >> $@

run-embench-verilator: $(embench_logs)
	cat $^ > logs/verilator/embench.log
###############################################################
#RVV tests

RVV_TESTS_DIR=rvv-tests
RVV_TESTS_TRACE_DIR=$(TAIGA_PROJECT_ROOT)/logs/sim-trace
RVV_TESTS_LOG_DIR=$(TAIGA_PROJECT_ROOT)/logs/verilator/rvv-tests

include $(RVV_TESTS_DIR)/common/rvv_tests.mk

rvv_tests_bins = $(addprefix $(RVV_TESTS_DIR)/build/bin/, $(rvv_tests))
rvv_tests_hw_init = $(addprefix $(RVV_TESTS_DIR)/build/bin/, $(addsuffix .hw_init, $(rvv_tests)))
rvv_tests_logs = $(addprefix $(RVV_TESTS_LOG_DIR)/, $(addsuffix .log, $(rvv_tests)))

.PHONY: build-rvv-tests
build-rvv-tests :
	$(MAKE) -C $(RVV_TESTS_DIR)
	
.PHONY : $(rvv_tests_bins)

$(rvv_tests_hw_init) : %.hw_init : %
	python3 $(ELF_TO_HW_INIT) $(ELF_TO_HW_INIT_OPTIONS) $< $@ $<.sim_init

$(RVV_TESTS_LOG_DIR)/%.log : $(RVV_TESTS_DIR)/build/bin/%.hw_init $(CVA5_SIM)
	mkdir -p $(RVV_TESTS_LOG_DIR)
	mkdir -p $(RVV_TESTS_TRACE_DIR)
	@echo $< > $@
	$(CVA5_SIM) \
	  "/dev/null"\
	  "/dev/null"\
	  $<\
	  $(VERILATOR_TRACE_FILE)\
	  >> $@

run-rvv-tests-verilator: $(rvv_tests_logs)
	cat $^ > logs/verilator/rvv-tests.log

###############################################################

.PHONY: clean-logs
clean-logs:
	rm -rf logs/verilator

.PHONY: clean
clean : clean-cva5-sim

