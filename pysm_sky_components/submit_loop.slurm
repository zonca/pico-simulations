#!/bin/bash -l
#SBATCH -q debug 
#SBATCH -n 1
#SBATCH -t 01:00:00    
#SBATCH -J run_pysm_pico

PY=/global/homes/z/zonca/condajupynersc/bin/python

for band in $(seq 1 21)
do
    $PY run_band.py $band &
done

FAIL = 0
for job in $(jobs -p)
do
    echo $job
    wait $job || let "FAIL+=1"
done

echo Failed processes: $FAIL
