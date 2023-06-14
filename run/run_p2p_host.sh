#!/bin/bash
#SBATCH -J OMB-Host-P2P
#SBATCH -o OMB-Host-P2p-%j.out 
#SBATCH -N 2
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A nstaff
##SBATCH -w nid[004074,004138]
#
#The -w option specifies which nodes to use for the test,
#thus controling the number of network hops between them.
#It should be modified for each system because
#the nid-topology differs with the system architechture.
#The nodes identified above are maximally distant
#on Perlmutter's Slingshot network.

#The number of NICs(j) and CPU cores (k) per node
#should be specified here.
j=1   #NICs per node
k=128 #Cores per node

#The paths to OMB and its point-to-point benchmarks
#should be specified here
OMB_DIR=./osu-micro-benchmarks-7.1-1
OMB_PT2PT=${OMB_DIR}/c/mpi/pt2pt/standard

srun -N 2 -n 2 \
     ${OMB_PT2PT}/osu_latency -m 8:8 

srun -N 2 -n 2 \
     ${OMB_PT2PT}/osu_bibw -m 1048576:1048576

srun -N 2 --ntasks-per-node=${j} \
     ${OMB_PT2PT}/osu_mbw_mr -m 16384:16384

srun -N 2 --ntasks-per-node=${k} \
     ${OMB_PT2PT}/osu_mbw_mr -m 16384:16384

srun -N 2 -n 2 \
     ${OMB_PT2PT}/osu_get_acc_latency -m 8:8 

