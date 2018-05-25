#!/bin/bash

#SBATCH --partition=debug

#SBATCH --account=mp107
#SBATCH --nodes=1
###SBATCH --ntasks=6
#SBATCH --time=00:10:00
#SBATCH --job-name=pico-focalplane
#SBATCH --output=pico-focalplane-%j.log

set -o errexit
set -v

srun -n 1 -N 1 toast_pico_pkl.py --bands bands.txt --pixels pixels.txt --fov 12.15
