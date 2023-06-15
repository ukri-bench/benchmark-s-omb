#!/bin/bash
#SBATCH -J OMB-Device-P2P
#SBATCH -o OMB-Device-P2P-%j.out
#SBATCH -N 2
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A nstaff_g
#SBATCH --gpus-per-node=4
##SBATCH -w nid[001652,001716]
#
#The -w option specifies which nodes to use for the test,
#thus controling the number of network hops between them.
#It should be modified for each system because
#the nid-topology differs with the system architechture.
#The nodes identified above are maximally distant
#on Perlmutter's Slingshot network.

#The number of NICs(j) and accelrators(a) per node
#should be specified here.
j=4 #NICs per node
a=4 #accelerator devices per node

#The paths to OMB and its point-to-point benchmarks
#should be specified here
OMB_DIR=../libexec/osu-micro-benchmarks
OMB_PT2PT=${OMB_DIR}/mpi/pt2pt/standard

srun -N 2 -n 2 \
     ${OMB_DIR}/get_local_rank \
     ${OMB_PT2PT}/osu_latency -m 8:8 -x 0 D D

srun -N 2 -n 2 \
     ${OMB_DIR}/get_local_rank \
     ${OMB_PT2PT}//osu_bw -m 1048576:1048576 -x 0 D D

srun -N 2 --ntasks-per-node=${j} \
     ${OMB_DIR}/get_local_rank  \
     ${OMB_PT2PT}//osu_mbw_mr -m 16384:16384 -x 0 D D

srun -N 2 --ntasks-per-node=${a} \
     ${OMB_DIR}/get_local_rank  \
     ${OMB_PT2PT}/osu_mbw_mr -m 16384:16384 -x 0 D D

srun -N 2 -n 2 \
     ${OMB_DIR}/get_local_rank \
     ${OMB_PT2PT}/osu_get_acc_latency -m 8:8 -x 0 D D 
