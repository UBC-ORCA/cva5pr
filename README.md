# CVA5PR Project Wiki

Top-level system wrapper for the CVA5 Processor.


### Background Information

See these links for additional background information:
* [Draft Papers Submitted to 2024 RISC-V_Summit North America](https://github.com/UBC-ORCA/RISC-V_Summit_2024)
* [Draft Proposed Composable Custom Extensions Specification](https://github.com/grayresearch/CX)

### Important

Always run, from the root project directory, before using any other scripts or Makefiles. This has to be used each time a new terminal is used:

```
source settings.sh
```

## Getting Started
**Step 1:** Set up the build environment

On Debian based distributions (including Ubuntu), various packages need to be present on the host and can be installed with:

```
sudo apt-get install git gcc g++ make texinfo bison flex libgmp-dev libmpfr-dev libmpc-dev ninja-build meson autoconf help2man
```

Note that `libgmp-dev`, `libmpfr-dev`, and `libmpc-dev` are required for building `gcc`. An alternative method to installing these packages is instead running
```./contrib/download_prerequisites```
in the `gcc` source directory. See [this website](https://gcc.gnu.org/wiki/InstallingGCC) for more details.

`picolibc` depends on `ninja-build` and `meson`. Consult their respective websites for alternative installation methods. ([ninja](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages), [meson](https://mesonbuild.com/Quick-guide.html)).

**Step 2:** Clone this repo and its submodules: `git clone --recurse-submodules -j8 https://github.com/UBC-ORCA/cva5pr.git`

**Step 3:** From the root project directory, install toolchains in `utils/scripts` (GNU, picolibc and verilator):
    `./utils/scripts/build-riscv-gnu.sh`, `./utils/scripts/build-riscv-picolibc.sh`, `./utils/scripts/build-verilator.sh`.

**Step 4:** run `cd cx_runtime`, and then run `make machine`. See `cx_runtime/README.md` for more information about adding new CXU's to the runtime.

## Makefile

The makefile supports building all of the benchmarks, linting the processor and running the benchmarks through the Verilator simulation environtment.  If CVA5 sources are updated, the simulation environment is automatically rebuilt when attempting to run any benchmark.

### Commands

- **build-embench** Builds the embench benchmark with CRC32 example
- **run-embench-verilator** Runs the embench benchmarks in the verilator simulation environment. Logs to: logs/verilator for summary and Logs to: logs/verilator/embench for individual benchmarks.

