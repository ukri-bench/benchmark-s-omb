#!/bin/bash
#SBATCH -J OMB-Host-Collective
#SBATCH -o OMB-Host-Collective-%j.out
#SBATCH -N 2
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A nstaff
#
#The -N option should be updated
#to use the full-system complement of CPU-only nodes

#The number of NICs(j) per node should be specified here.
j=1 #NICs per node

#The paths to OMB and its collective benchmarks
#should be specified here
OMB_DIR=../libexec/osu-micro-benchmarks
OMB_COLL=${OMB_DIR}/mpi/collective/blocking


#Compute the total number of tasks 
#to run on the full system (n_any),
#and the next smaller odd number (n_odd)
n_any = $( SLURM_JOB_NUM_NODES * j )
n_odd = n_any
if( n_any % 2 ):
  n_odd = n_any - 1


srun -N ${SLURM_NNODES} -n ${n_any} --ntasks-per-node=${j} \
     ${OMB_COLL}/osu_allreduce -m 8:8

srun -N ${SLURM_NNODES} -n ${n_odd} --ntasks-per-node=${j} \
     ${OMB_COLL}/osu_allreduce -m -m 26214400:26214400

srun -N ${SLURM_NNODES} -n ${n_odd} --ntasks-per-node=${j} \
     ${OMB_COLL}/osu_alltoall -m 1048576:1048576


