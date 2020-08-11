#Additional Wikis

This readme contains the steps to build the toolchain required to run Benchmarks on Taiga in Verilator as well as using our project Makefile. Head to our [Wiki Page](https://gitlab.com/sfu-rcl/taiga-project/-/wikis/home) for additional tutorials/documentation.

# Taiga Project

Top-level system wrapper for the Taiga Processor.


### Important

Always run, from the root project directory, before using any other scripts or Makefiles:

```
source settings.sh
```


## Getting Started
**Step 1:** Download and setup the project:
```
git clone git@gitlab.com:sfu-rcl/taiga-project.git
cd taiga-project
git submodule update --init
```

**Step 2:** From the root project directory, source the settings script which sets all needed environment variables.

```
source settings.sh
```

**Step 3:** From the root project directory, build the toolchain.

```
./build-tool-chain.sh
```

It is very likely that you will encounter errors while building the tool-chain if you haven't built a cross-compiled tool-chain on your system before. **We suggest you read the next section to reduce the possibility of build errors**, as currently if the build was to fail, it would start from the first library being built even if some libraries were successfully built/installed.

## Common Build Errors

### GCC Prerequisites
There are several dependencies that GCC has. From [this website](https://gcc.gnu.org/wiki/InstallingGCC), we learn we can run the following command *within the GCC installation folder* to install the perquisites:

<pre>
./contrib/download_prerequisites
</pre>

## Makefile

The makefile supports building all of the benchmarks, linting the processor and running the benchmarks through the Verilator simulation environtment.  If Taiga sources are updated, the simulation environment is automatically rebuilt when attempting to run any benchmark.

### Commands
- **lint** Performs a Verilator lint on the Taiga sources
- **lint-full** Performs a Verilator lint -Wall on the Taiga sources

- **build-coremark** Builds the coremark benchmark
- **run-coremark-verilator** Runs the coremark benchmark in the verilator simulation environment.  (Note: coremark has a runtime of approximately 20 minutes). Logs to: logs/verilator.

- **build-embench** Builds the embench benchmark
- **run-embench-verilator** Runs the embench benchmarks in the verilator simulation environment. Logs to: logs/verilator for summary and Logs to: logs/verilator/embench for individual benchmarks.

- **run-dhrystone-verilator** Runs (and builds if necessary) the dhrystone benchmark in the verilator simulation environment. Logs to: logs/verilator.
- **run-example-c-project-verilator** Runs (and builds if necessary) the example c project benchmark in the verilator simulation environment. Logs to: logs/verilator.

- **run-compliance-tests-verilator** Runs the compliance tests (rv32i and rv32im) in the verilator simulation environment. Logs to: logs/verilator/compliance for individual tests.

- **clean-taiga-sim** removes the taiga-sim (verilator simulation environment) build directory
- **clean-logs** removes all generated logs
- **clean** performs all clean-* commands












