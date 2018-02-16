#!/bin/bash -l
#SBATCH -q shared 
#SBATCH -n 1
#SBATCH -t 01:00:00    
#SBATCH -J run_pysm_pico
#SBATCH --array=1-2

PY=/global/homes/z/zonca/condajupynersc/bin/python

$PY run_band.py $SLURM_ARRAY_TASK_ID
