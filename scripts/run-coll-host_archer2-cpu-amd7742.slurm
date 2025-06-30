#!/bin/bash
#SBATCH --job-name=OMB_coll_host
#SBATCH --time=0:20:0
#SBATCH --nodes=256
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1

#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --account=z19
#SBATCH --nodes=4
#
#The -N option should be updated
#to use the full-system complement of CPU-only nodes

#The number of NICs(j) per node should be specified here.
j=2 #NICs per node

#The paths to OMB and its collective benchmarks
#should be specified here
OMB_DIR=../libexec/osu-micro-benchmarks
OMB_COLL=${OMB_DIR}/mpi/collective

#Compute the total number of ranks
#to run on the full system (n_any),
#and the next smaller odd number (n_odd)
N_any=$(( SLURM_JOB_NUM_NODES     ))
n_any=$(( SLURM_JOB_NUM_NODES * j ))
N_odd=$N_any
n_odd=$n_any
if [ $(( n_any % 2 )) -eq 0 ]; then
    n_odd=$(( n_any - 1 ))
    if [ $j -eq 1 ]; then
	N_odd=$n_odd
    fi
fi

timestamp=$(date '+%Y%m%d%H%M')
outfile="omb-host-coll_${N_any}nodes_${n_any}procs_${timestamp}.res"

echo -n Nodes:$N_any   Tasks:$n_any > ${outfile}
srun -N ${N_any} -n ${n_any} --ntasks-per-node=${j} \
     ${OMB_COLL}/osu_allreduce -m 8:8 >> ${outfile}
echo

echo -n Nodes:$N_any   Tasks:$n_any
srun -N ${N_any} -n ${n_any} --ntasks-per-node=${j} \
     ${OMB_COLL}/osu_allreduce -m 26214400:26214400 >> ${outfile}
echo

echo -n Nodes:$N_odd   Tasks:$n_odd
srun -N ${N_odd} -n ${n_odd} --ntasks-per-node=${j} \
     ${OMB_COLL}/osu_alltoall -m 1048576:1048576 >> ${outfile}
echo

