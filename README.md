# Taiga Project Wiki

This readme contains the steps to build the toolchain required to run Benchmarks on CVA5 (formerly Taiga) in Verilator as well as using our project Makefile. 

Head to our [Wiki Page](https://gitlab.com/sfu-rcl/taiga-project/-/wikis/home) for additional tutorials/documentation detailing:
- How to run through simulation
- How to run through hardware
- Adding your own functional units to processor pipeline
- Recommended readings, SystemVerilog resources, etc...

# Taiga Project

Top-level system wrapper for the CVA5 Processor.


### Important

Always run, from the root project directory, before using any other scripts or Makefiles. This has to be used each time a new terminal is used:

```
source settings.sh
```
taiga-project will download and install specific versions of the tool-chain, even if you have part of the tool-chain installed due to previous projects, we strongly suggest that the versions downloaded by the scripts should be used.

## Getting Started
**Step 1:** Set up the build environment

On Debian based distributions (including Ubuntu), various packages need to be present on the host and can be installed with:

```
sudo apt-get install git gcc g++ make texinfo bison flex libgmp-dev libmpfr-dev libmpc-dev ninja-build meson autoconf
```

Note that `libgmp-dev`, `libmpfr-dev`, and `libmpc-dev` are required for building `gcc`. An alternative method to installing these packages is instead running
```./contrib/download_prerequisites```
in the `gcc` source directory. See [this website](https://gcc.gnu.org/wiki/InstallingGCC) for more details.

`picolibc` depends on `ninja-build` and `meson`. Consult their respective websites for alternative installation methods. ([ninja](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages), [meson](https://mesonbuild.com/Quick-guide.html)).

**Step 2:** Download and set up the project:

```
git clone git@gitlab.com:sfu-rcl/taiga-project.git
cd taiga-project
git submodule update --init
```

To save on bandwidth, you may want to shallowly clone some of the submodules yourself. You can do this by making use of the `--depth 1` and `--branch branchname` flags in the `git clone` command.

**Step 3:** From the root project directory, build the toolchain.

```
./build-tool-chain.sh
```

To speed up the installation process, add the line:
`export MAKEFLAGS='-j$(nproc)'` (or however many cores you want to use) to the start of `build-tool-chain.sh`


## Makefile

The makefile supports building all of the benchmarks, linting the processor and running the benchmarks through the Verilator simulation environtment.  If CVA5 sources are updated, the simulation environment is automatically rebuilt when attempting to run any benchmark.

### Commands
- **lint** Performs a Verilator lint on the CVA5 sources
- **lint-full** Performs a Verilator lint -Wall on the CVA5 sources

- **build-coremark** Builds the coremark benchmark
- **run-coremark-verilator** Runs the coremark benchmark in the verilator simulation environment.  (Note: coremark has a runtime of approximately 20 minutes). Logs to: logs/verilator.

- **build-embench** Builds the embench benchmark
- **run-embench-verilator** Runs the embench benchmarks in the verilator simulation environment. Logs to: logs/verilator for summary and Logs to: logs/verilator/embench for individual benchmarks.

- **run-dhrystone-verilator** Runs (and builds if necessary) the dhrystone benchmark in the verilator simulation environment. Logs to: logs/verilator.
- **run-example-c-project-verilator** Runs (and builds if necessary) the example c project benchmark in the verilator simulation environment. Logs to: logs/verilator.

- **run-compliance-tests-verilator** Runs the compliance tests (rv32i and rv32im) in the verilator simulation environment. Logs to: logs/verilator/compliance for individual tests.

- **clean-cva5-sim** removes the cva5-sim (verilator simulation environment) build directory
- **clean-logs** removes all generated logs
- **clean** performs all clean-* commands

