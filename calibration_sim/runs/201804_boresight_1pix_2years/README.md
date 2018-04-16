PICO Calibration simulation
==========================

April 2018


## Software versions

* TOAST after pointing #224 and timing fix #223: `30d2d66908176fa35d4041019816529f5d5d9587`
* `pico-simulations`: `e27617afb186128d99f6221234a7c09fd632d761`

both tagged: `201804_boresight_1pix_2years`

* <https://github.com/zonca/toast/releases/tag/201804_boresight_1pix_2years>
* <https://github.com/zonca/pico-simulations/releases/tag/201804_boresight_1pix_2years>

## Configuration

* 1 pixel in band 9 at 89.6 GHz
* 2 detectors 
* boresight pointing
* only solar dipole due to current restriction of the calibration code
* PySM sky
* 2 years

* see the [SLURM script and other configuration files](https://github.com/zonca/pico-simulations/tree/e27617afb186128d99f6221234a7c09fd632d761/calibration_sim)



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
