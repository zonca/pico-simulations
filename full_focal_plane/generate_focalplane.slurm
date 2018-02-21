#!/bin/bash

#SBATCH --partition=debug

#SBATCH --account=mp107
#SBATCH --nodes=1
###SBATCH --ntasks=6
#SBATCH --time=00:30:00
#SBATCH --job-name=pico-focalplane
#SBATCH --output=pico-focalplane-%j.log

set -o errexit
set -v

cd ../toast-pico
srun -n 1 -N 1 toast_pico_pkl.py --bands params/bands.txt --pixels params/pixels.txt --fov 12.15
