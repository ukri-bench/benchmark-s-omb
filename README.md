#  OSU Micro-Benchmark

The OSU micro-benchmark suite (OMB) tests the performance of
network communication functions for MPI and other communication interfaces.

The Offeror should not modify the benchmark code for this benchmark.

## Installation

The OMB source code is distributed by the
[MVAPICH website](https://mvapich.cse.ohio-state.edu/benchmarks/).
It can be downloaded and unpacked using the commands
```bash
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.1-1.tar.gz
tar -xzf osu-micro-benchmarks-7.1-1.tar.gz
```

Compiling the OMB tests for CPUs follows the common configure-make procedure:
```bash
./configure CC=/path/to/mpicc CXX=/path/to/mpicxx
make
make install
```

OMB also supports the GPUs through ROCm, CUDA and OpenACC extensions.
The file `osu-micro-benchmarks-7.1.1/README`
provides several examples of compiling with these extensions.

## Required Tests

The full OMB suite tests numerous communication patterns.
Only the benchmarks listed in the following table are required
for NERSC-10 testing:

| Test                | Message <br> Size | Nodes <br> Used | Ranks <br> Used |
|---                  |---                |--- |--- |
| osu_latency         |  8  B | 2 | 1 per node |
| osu_bibw            |  1 MB | 2 | 1 per node |
| osu_mbw_mr          | 16 KB | 2 | Host-to-Host (two tests) :<br>     1 per NIC<br>    1 per core <br> Device-to-Device:<br>    1 per accelerator |
| osu_get_acc_latency |  8  B | 2 | 1 per node |
| osu_allreduce       | 8B, 25 MB | full-system | 1 per NIC |
| osu_alltoall        |  1 MB | full-system | 1 per NIC | 

For the point-to-point tests (those that that use two (2) nodes),
the nodes should be the maximum distance (number of hops) apart
in the network topology.

On systems that include accelerator devices,
the tests should be executed twice:
once to test performance to and from host memory,
and again to to measure latency to and from device memory.
Toggling between these tests is controlled by (**Help me, Taylor**).
by the"device" option described below.

## Execution

**@TAYLOR, I need your help filling in this section.
In particular, I don't know how to use the device option for p2p or collectives.
Are these compile-time options, runtime-options or both? We need an example of what we expect people to do.**

## Reporting Results

Note that the benchmark will generate more output data than is requested, the
offeror needs only to report the benchmark values requested.
Additional data may be provided if desired.

The offeror should provide a copy of the Makefile and configuration
settings used for the benchmark results. 

The benchmark should be compiled and run on the compiler and MPI environment
which will be provided on the proposed machine.

Reported results will be subject to acceptance testing using the NERSC-10
benchmark on final delivered hardware.


