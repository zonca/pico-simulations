#!/bin/bash

#SBATCH --partition=debug

#SBATCH --account=mp107
#SBATCH --nodes=1
#SBATCH --time=00:30:00
#SBATCH --job-name=pico-full-focal-plane
#SBATCH --output=out_tiny_satellite_edison_%j.log
#SBATCH --mail-type=ALL

set -o errexit
set -v



echo Starting slurm script at $(date)

echo -e "\n-----------------------------------------------------------------------"
echo -e "ENVIRONMENT:\n"
env | sort -d
echo -e "-----------------------------------------------------------------------\n"
echo "PYTHON: $(which python)"
echo "PYTHON VERSION: $(python --version &> /dev/stdout)"
echo ""

pstr=edison
outdir="out_tiny_satellite_${pstr}_50days"
mkdir -p "${outdir}"

# This script assumes that you are running at NERSC and have already
# loaded the toast module for the correct machine / configuration.

# This should be the same as the --nodes option above
nodes=$SLURM_JOB_NUM_NODES

# How many processes are we running per node?  Handle
# the case of a very small simulation.
if [ $nodes -lt 50 ]; then
    node_proc=1
else
    node_proc=8
fi

# The executable script

ex=$(which toast_satellite_sim.py)
echo "Using ${ex}"

# Scan strategy parameters from a file

parfile="pico_scanning_noise.par"

# Observations

nobs=1

groupnodes=0

# Data distribution parameters.  We are distributing by detector,
# so if our number of processes in a group is larger than the number
# of detectors this is bad.  In that case, set the group size to 
# one, so we have many more groups, each assigned

groupsize=1

madam="pico_madam.par"
fpfile="focalplane/pico_09.pkl"

# The commandline

com="${ex} @${parfile} \
--toast-output-dir "${outdir}" \
--toast-timing-fname "timing_report_main" \
--groupsize ${groupsize} \
--madam \
--madampar ${madam} \
--fp ${fpfile} \
--numobs ${nobs} \
--outdir ${outdir}/out \
$@ \
"

#--- Hardware configuration ----

# Hyperthread CPUs per physical core
cpu_per_core=2

# Physical cores we are using
node_cores=24

node_thread=$(( node_cores / node_proc ))
node_depth=$(( cpu_per_core * node_thread ))
procs=$(( nodes * node_proc ))

export OMP_NUM_THREADS=${node_thread}
export OMP_PLACES=threads
export OMP_PROC_BIND=spread
export TOAST_NODE_COUNT=${nodes}
export TOAST_NUM_THREADS=${OMP_NUM_THREADS}
echo "OpenMP # threads: ${OMP_NUM_THREADS}"
echo "TOAST # threads: ${TOAST_NUM_THREADS}"

# Set TMPDIR to be on the ramdisk
export TMPDIR=/dev/shm

run="srun --cpu_bind=cores -n ${procs} -N ${nodes} -c ${node_depth}"

echo Calling srun at $(date)

: ${LOG_OUT:="${outdir}/log"}
echo "${run} ${com}"
eval ${run} ${com} > ${LOG_OUT} 2>&1

echo End slurm script at $(date)
