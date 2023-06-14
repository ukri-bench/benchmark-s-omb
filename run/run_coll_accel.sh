#!/bin/bash
#SBATCH -J OMB-Device-Collective
#SBATCH -o OMB-Device-Collective-%j.out
#SBATCH -N 2
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A nstaff_g
#SBATCH -G 4
#
#The -N option should be updated
#to use the full-system complement of accelerated nodes

#The number of NICs(j) and accelerators(a) per node
#should be specified here
j=4 #NICs per node
a=4 #accelerator devices per node

#OMB_DIR 
OMB_DIR=./osu-micro-benchmarks-7.1-1
OMB_COLL=${OMB_DIR}/c/mpi/collective/blocking

#Compute the total number of tasks 
#to run on the full system (n_any),
#and the next smaller odd number (n_odd)
n_any = $( SLUM_JOB_NUM_NODES * a )
n_odd = n_any
if( n_any%2 ):
  n_odd=n_any-1


srun -N ${SLURM_NNODES} -n ${n_any} --ntasks-per-node=${a} \
     ${OMB_DIR}/get_local_rank  \
     ${OMB_COLL}/osu_allreduce -m 8:8 -d cuda

srun -N ${SLURM_NNODES} -n ${n_odd} --ntasks-per-node=${a} \
     ${OMB_DIR}/get_local_rank  \
     ${OMB_COLL}/osu_allreduce -m 26214400:26214400 -d cuda

srun -N ${SLURM_NNODES} -n ${n_odd} --ntasks-per-node=${a} \
     ${OMB_DIR}/get_local_rank \
     ${OMB_COLL}/osu_alltoall -m 1048576:1048576 -d cuda


