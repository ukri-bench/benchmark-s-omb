=========================================================
OSU MPI Benchmark Suite
=========================================================

The OSU benchmark suite tests the performance of MPI communication functions.

The Offeror should not modify the benchmark code for this benchmark.

A simple Makefile is provided which may be modified to support the local
compilation/MPI runtime environment.

The following benchmarks are included in the NERSC-10 testing:

* osu_latency
* osu_bibw
* osu_mbw_mr
* osu_get_acc_latency
* osu_allreduce
* osu_alltoall

=========================================================

II. Running Benchmarks

#osu_latency
Number of nodes: Two nodes are used in this test.  The nodes should be the maximum distance (number of hops) apart in the network topology.
Ranks per node, accelerator, NIC: Testing is done with a single rank per node.  On systems which include accelerators, the device option will be used to measure latency to and from device memory.
Message size: 8B

* osu_bibw
Number of nodes: Two nodes are used in this test.  The nodes should be the maximum distance (number of hops) apart in the network topology.
Ranks per Node, Accelerator, NIC: Testing is done with a single rank per node.  On systems which include accelerators, the device option will be used to measure bandwidth to and from device memory.
Message size: 1MB

* osu_mbw_mr
Number of nodes: Two nodes are used in this test.  The nodes should be the maximum distance (number of hops) apart in the network topology.
Ranks per Node, Accelerator, NIC: Testing is done with two nodes.  For a host-to-host test one rank per NIC and one rank per core.  On systems which include accelerators, the device option will be used with one rank per accelerator..
Message size: 16KB

* osu_get_acc_latency
Number of nodes: Two nodes are used in this test.  The nodes should be the maximum distance (number of hops) apart in the network topology.
Ranks per Node, Accelerator, NIC: Testing is done with a single rank per node.  On systems which include accelerators, the device option will be used to measure latency to and from device memory.
Message size: 8B

* osu_allreduce
Number of nodes: This is a full system test.  
Ranks per Node, Accelerator, NIC: Testing is done with a single rank per NIC.  On systems which include accelerators, the device option will be used to measure performance to and from device memory.
Message size: 8B, 25MB

* osu_alltoall
Number of nodes: This test runs across the full system and must not be a power of two..  
Ranks per Node, Accelerator, NIC: Testing is done with a single rank per NIC.  On systems which include accelerators, the device option will be used to measure performance to and from device memory.
Message size: 1MB

=========================================================

III. Reporting Results
Note that the benchmark will generate more output data than is requested, the
offeror needs only to report the benchmark values requested (but is free
to provide additional data if desired).

The offeror should provide a copy of the Makefile and configuration
settings used for the benchmark results. 

The benchmark should be compiled and run on the compiler and MPI environment
which will be provided on the proposed machine.

Reported results will be subject to acceptance testing using the NERSC-10
benchmark on final delivered hardware.

=========================================================
