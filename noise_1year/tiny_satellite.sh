#!/bin/bash

outdir="out"
mkdir -p "${outdir}"

# This script assumes that you have toast and all dependencies
# installed and loaded in your environment.

# Generate the focalplane file if it does not already exist.

ndet=1

fpfile="pico_1.pkl"

# The executable script

ex=$(which toast_satellite_sim.py)
echo "Using ${ex}"

# Scan strategy parameters from a file

parfile="pico_scanning.par"

# Observations

nobs=2

# Map making parameters

nside="512"

# Data distribution parameters.  Group size is one process.

groupsize=1

# The commandline

com="${ex} @${parfile} \
--groupsize ${groupsize} \
--fp ${fpfile} \
--nside ${nside} \
--numobs ${nobs} \
--madam \
--noisefilter \
--baseline 1.0 \
--outdir ${outdir}/out \
"

# Use 2 processes, each with 2 threads

procs=2
threads=2

export OMP_NUM_THREADS=${threads}

run="mpirun -np ${procs}"

echo "${run} ${com}"
eval ${run} ${com} > "${outdir}/log" 2>&1

