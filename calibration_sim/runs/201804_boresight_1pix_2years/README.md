PICO Calibration simulation
==========================

May 2018


## Software versions

TOAST and `pico-simulations`, both tagged: `201804_boresight_1pix_2years`

* <https://github.com/zonca/toast/releases/tag/201804_boresight_1pix_2years>
* <https://github.com/zonca/pico-simulations/releases/tag/201804_boresight_1pix_2years>

## Configuration

* 1 pixel in band 9 at 89.6 GHz
* 2 detectors 
* boresight pointing
* only solar dipole due to current restriction of the calibration code
* PySM sky
* 2 years

* see the [SLURM script and other configuration files](https://github.com/zonca/pico-simulations/tree/201804_boresight_1pix_2years/calibration_sim)

## Discussion and plots

<https://github.com/zonca/pico-simulations/issues/16>

Following calibration simulation: <https://zzz.physics.umn.edu/ipsig/calibration_simulations>

## Results location

Output IQU maps destriped with Madam and timelines, 1 FITS file per day with:

* pointing: theta, phi, psi
* dipole
* foreground
* total

NERSC

`/global/cscratch1/sd/zonca/pico/cal_sims/201804_boresight_1pix_2years`

tape

`~zonca/pico/201804_boresight_1pix_2years`

## Issues

These simulations are affected by a coordinate rotation issue in the PySM operator, see https://github.com/hpc4cmb/toast/issues/242
Therefore Q and U maps are wrong.
