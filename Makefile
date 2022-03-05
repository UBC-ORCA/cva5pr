#python script creats ram init files for simulation and hardware
###############################################################
RISCV_PREFIX ?= riscv32-unknown-elf-
ELF_TO_HW_INIT_OPTIONS ?= $(RISCV_PREFIX) 0x80000000 131072
###############################################################

###############################################################
#Verilator Parameters
TRACE_ENABLE = False
VERILATOR_TRACE_FILE = $(TAIGA_PROJECT_ROOT)/logs/sim-trace/verilator_trace.vcd


###############################################################
#CVA5 core makefile
-include $(CVA5_DIR)/tools/cva5.mak
###############################################################


###############################################################
#Embench
#Assumes binaries are in the BENCHMARK_DIR
EMBENCH_DIR=benchmarks/embench
EMBENCH_LOG_DIR=$(TAIGA_PROJECT_ROOT)/logs/verilator/embench
EMBENCH_BENCHMARKS =  \
aha-mont64 \
crc32 \
cubic \
edn \
huffbench \
matmult-int \
md5sum \
minver \
nbody \
nettle-aes \
nettle-sha256 \
nsichneu \
picojpeg \
primecount \
qrduino \
sglib-combined \
slre \
st \
statemate \
tarfind \
ud \
wikisort

#add file path to benchmarks
embench_bins = $(addprefix $(EMBENCH_DIR)/build/bin/, $(EMBENCH_BENCHMARKS))
embench_hw_init = $(addprefix $(EMBENCH_DIR)/build/bin/, $(addsuffix .hw_init, $(EMBENCH_BENCHMARKS)))
embench_logs = $(addprefix $(EMBENCH_LOG_DIR)/, $(addsuffix .log, $(EMBENCH_BENCHMARKS)))

#embench benchmarks copied into a bin folder to simplify makefile rules
.PHONY: build-embench
build-embench :
	cd $(EMBENCH_DIR);\
	./build_all.py --clean --builddir=build --arch=riscv32 --chip=generic --board=taiga-picolibc --cflags="--specs=picolibc.specs --crt0=hosted -march=rv32im -mabi=ilp32 -mcmodel=medlow -O2 -ffunction-sections" --ldflags="--specs=picolibc.specs --crt0=hosted -Xlinker --defsym=__mem_size=131072 -Wl,--print-memory-usage" --cc-input-pattern="-c {0}" --user-libs="-lm"
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


###############################################################
#Coremark
COREMARK_DIR=benchmarks/taiga-coremark
.PHONY: build-coremark
build-coremark:
	$(MAKE) -C  $(COREMARK_DIR) compile PORT_DIR=taiga ITERATIONS=5000;
	cd $(MAKEFILE_DIR);
	python3 $(ELF_TO_HW_INIT) $(ELF_TO_HW_INIT_OPTIONS) $(COREMARK_DIR)/coremark.bin $(COREMARK_DIR)/coremark.hw_init $(COREMARK_DIR)/coremark.sim_init

.PHONY: run-coremark-verilator
run-coremark-verilator : build-coremark $(CVA5_SIM)
	mkdir -p logs/verilator
	$(CVA5_SIM) \
	  "/dev/null"\
	  "/dev/null"\
	  $(COREMARK_DIR)/coremark.hw_init\
	  $(VERILATOR_TRACE_FILE)\
	  > logs/verilator/coremark.log
###############################################################


###############################################################
#Compliance Tests
COMPLIANCE_DIR=benchmarks/riscv-compliance
COMPLIANCE_LOG_DIR=$(TAIGA_PROJECT_ROOT)/logs/verilator/compliance
COMPLIANCE_TARGET=rv32im
.PHONY: run-compliance-tests-verilator
run-compliance-tests-verilator: $(CVA5_SIM)
	mkdir -p logs/verilator/compliance
	$(MAKE) -C $(COMPLIANCE_DIR) clean
	$(MAKE) -C $(COMPLIANCE_DIR)\
	  RISCV_TARGET=taiga\
	  RISCV_DEVICE=$(COMPLIANCE_TARGET)\
	  RISCV_PREFIX=$(RISCV_PREFIX)\
	  ELF_TO_HW_INIT_OPTIONS="$(ELF_TO_HW_INIT_OPTIONS)"\
	  TAIGA_SIM_BINARY=$(CVA5_SIM)\
	  VERILATOR_TRACE_FILE=$(VERILATOR_TRACE_FILE)\
	  COMPLIANCE_LOG_DIR=$(COMPLIANCE_LOG_DIR)
###############################################################


###############################################################
#Dhrystone
DHRYSTONE_DIR=benchmarks/taiga-dhrystone
.PHONY: run-dhrystone-verilator
run-dhrystone-verilator : $(CVA5_SIM)
	mkdir -p logs/verilator
	$(MAKE) -C $(DHRYSTONE_DIR) all
	$(CVA5_SIM) \
	  "/dev/null"\
	  "/dev/null"\
	  $(DHRYSTONE_DIR)/dhrystone.hw_init\
	  $(VERILATOR_TRACE_FILE)\
	  > logs/verilator/dhrystone.log
###############################################################

###############################################################
#Example C Project
EXAMPLE_C_PROJECT_DIR=benchmarks/taiga-example-c-project
.PHONY: run-example-c-project-verilator
run-example-c-project-verilator : $(CVA5_SIM)
	mkdir -p logs/verilator
	$(MAKE) -C $(EXAMPLE_C_PROJECT_DIR) all
	$(CVA5_SIM) \
	  "/dev/null"\
	  "/dev/null"\
	  $(EXAMPLE_C_PROJECT_DIR)/hello_world.hw_init\
	  $(VERILATOR_TRACE_FILE)\
	  > logs/verilator/hello_world.log
###############################################################

.PHONY: clean-logs
clean-logs:
	rm -rf logs/verilator

.PHONY: clean
clean : clean-cva5-sim

