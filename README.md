#  OSU Micro-Benchmark

**Note:** This benchmark/repository is closely based on the one used for the [NERSC-10 benchmarks](https://www.nersc.gov/systems/nersc-10/benchmarks/)

The OSU micro-benchmark suite (OMB) tests the performance of network
communication functions for MPI and other communication interfaces.



## Status

Stable

## Maintainers

[@aturner-epcc](https://github.com/aturner-epcc)

## Overview

### Software

- [https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5-1.tar.gz](https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5-1.tar.gz)

### Architectures

- CPU: x86, Arm
- GPU: NVIDIA, AMD, Intel

### Languages and programming models

- Programming languages: C
- Parallel models: MPI, CAF
- Accelerator offload models: CUDA, ROCm, OpenACC

## Building the benchmark

At the moment, only manual build instructions are available. We plan to add Spack
build instructions in the future.

### Permitted modifications

If being used for procurement, the bidder should not modify the benchmark
code for this benchmark.

### Manual build

The OMB source code is distributed by the [MVAPICH
website](https://mvapich.cse.ohio-state.edu/benchmarks/). It can be
downloaded and unpacked using the commands
```bash
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5-1.tar.gz
tar -xzf osu-micro-benchmarks-7.5-1.tar.gz
```

Compiling the OMB tests for CPUs follows the common configure-make
procedure:
```bash
./configure CC=/path/to/mpicc CXX=/path/to/mpicxx --prefix=$(pwd)
make
make install
```
The `--prefix=$(pwd)` will cause OMB to be installed in the current
working directory. In particular, it will create a directory named
`libexec/osu-micro-benchmarks` where the benchmark executables will be
found.


OMB also supports the GPUs through ROCm, CUDA and OpenACC extensions.
The file `osu-micro-benchmarks-7.5.1/README` provides several examples
of compiling with these extensions.

We provide example build scripts for the benchmarks on selected systems.
They are provided for convenience and is not intended to prescribe how
to build the OMB benchmarks.

- [scripts/build-archer2-cpu-amd7742.sh](scripts/build-archer2-cpu-amd7742.sh)

OMB provides a script named `get_local_rank` that may (optionally) used
as a wrapper function when launching the OMB tests. Its purpose is to
define an the `LOCAL_RANK` environment variable before starting the
target executable (e.g. `osu_latency`). `LOCAL_RANK` enumerates the
ranks on each node so that the MPI library can control affinity between
ranks and processors. Different MPI launchers expose the local rank
information in different ways, and
`libexec/osu-micro-benchmarks/get_local_rank` should be modified
accordingly. Notes describing the appropriate modifications are included
within the `get_local_rank` script.

As an example, on ARCHER2, MPI jobs are started using the SLURM PMI, and
the `LOCAL_RANK` may be set using `export LOCAL_RANK=$SLURM_LOCALID`.

## Running the benchmark

At the moment, only manual run instructions are available.

### Required Tests

The full OMB suite tests numerous communication patterns. Only the
benchmarks listed in the following table are required:


| Test                |Description| Message <br> Size | Nodes <br> Used | Ranks <br> Used |
|---                  |---        |---                |--- |--- |
| osu_latency         | Point-to-Point <br> Latency |  8  B | 2 | 1 per node |
| osu_bibw            | Point-to-Point <br> Bi-directional <br> bandwidth |  1 MB | 2 | 1 per node |
| osu_mbw_mr          | Point-to-Point <br> Multi-Bandwidth <br>& Message Rate | 16 KB | 2 | Host-to-Host (two tests) :<br>     - 1 per NIC<br>    - 1 per core <br> Device-to-Device (two tests):<br>    - 1 per NIC<br>    - 1 per accelerator |
| osu_get_acc_latency | Point-to-Point <br> One-sided Accumulate Latency |  8  B | 2 | 1 per node |
| osu_allreduce       | All-reduce Latency | 8B, 25 MB | full-system | 1 per NIC |
| osu_alltoall        | All-to-all Latency |  1 MB | full-system | 1 per NIC <br> odd process count |

For the point-to-point tests (those that that use two (2) nodes), the
nodes should be the maximum distance (number of hops) apart in the
network topology.

For the all-to-all test, the total number of ranks must be odd in order
to circumvent software optimisations that would avoid stressing the
network bisection bandwidth. If the product Nodes_Used x NICs_per_node
is even, then the number of ranks used should be one less than this
product.

On systems that include accelerator devices, the tests should be
executed twice: once to test performance to and from host memory, and
again to to measure latency to and from device memory. Toggling between
these tests requires configuring and compiling with the appropriate
option (see `./configure --help`).

An example of this for CUDA would be configuring `--enable-cuda=basic
--with-cuda=[CUDA installation path]`, as well as providing paths and
linking to the appropriate libraries.

### Benchmark execution

Examples of job scripts that run the required tests
are located in the `run` directory.
The job scripts should be edited to reflect
the architecture of the target system as follows:

- For all tests (`run_*.sh`),
  specify the number of NICs per node
  by setting the `j` variable`.

- For point-to-point tests (`run_p2p_[host,accel].sh`),
  specify a pair of maximally distant nodes
  by setting the `SBATCH -w` option.
  Note that selection of an appropriate pair of nodes
  requires knowing the nodes' placement on the network topology.
  Other mechanisms for controling node placement (besides `-w`)
  may be used if available.

- For tests of collective operations (`run_coll_[host,accel].sh`),
  specify the number of nodes in the full system
  by setting the `SBATCH -N` option.

- For point-to-point tests between host processors (`run_p2p_host.sh`),
  specify the number of CPU cores per node
  by setting the `k` variable.

- For tests using accelerator devices (`run_[p2p,coll]_accel.sh`),
  specify the number of devices per node
  by setting the `a` variable.

- For tests using accelerator devices (`run_[p2p,coll]_accel.sh`),
  specify the device interface interface to be used
  by providing the appropriate option to the `osu_<test>` command
  (i.e. `-d[ROCm,CUDA,OpenACC]` ).

Runtime options to control the execution of each test can be viewed by
supplying the `--help` option. The number of iterations (`-i`) should be
changed from its default value. The `-x` option should not be used to
exclude warmup iterations; results should include the warmup iterations.
If the test is using device memory, then it is enabled by the `-d`
device option with the appropriate interface (e.g. `-d [ROCm, CUDA,
OpenACC] D D`).

## Reporting Results

Note that the benchmark will generate more output data than is
requested, the offeror needs only to report the benchmark values
requested. Additional data may be provided if desired.

The offeror should provide a copy of the Makefile and configuration
settings used for the benchmark results.

The benchmark should be compiled and run on the compiler and MPI
environment that will be provided on the proposed machine.

## Example performance data

### ARCHER2

MPI collectives, 256 nodes, 2 MPI processes per node:

```
Nodes:256 Tasks:512 Per Node:2
# OSU MPI Allreduce Latency Test v7.5
# Datatype: MPI_INT.
# Size       Avg Latency(us)
8                      33.58

# OSU MPI Allreduce Latency Test v7.5
# Datatype: MPI_INT.
# Size       Avg Latency(us)
26214400            29942.75

# OSU MPI All-to-All Personalized Exchange Latency Test v7.5
# Datatype: MPI_CHAR.
# Size       Avg Latency(us)
1048576             87258.19
```

## License

This benchmark description and associated files are released under the
MIT license.
