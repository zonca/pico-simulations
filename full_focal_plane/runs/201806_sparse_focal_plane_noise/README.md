PICO Sparse focal plane simulation of noise
==========================

June 2018
zonca@sdsc.edu


## Software versions

* TOAST: `119db6ae8204230aafbaf0cb1d46d84f8d36cbf3`
* `pico-simulations`: Tag `201806_sparse_focal_plane_noise`

## Configuration

* All 21 bands
* pixels/wafer reduced to 7 for all bands
* sampling frequency reduced all to 63 Hz, unless it was already lower
* hitmaps and noise covariance matrices corrected to be representative of the full focal plane and nominal sampling frequency
* baseline 1/f and white noise
* 1 year

* see the [SLURM scripts and other configuration files](https://github.com/zonca/pico-simulations/tree/201806_sparse_focal_plane_noise/full_focal_plane)



## Results location

Available maps:

* IQU maps binned and destriped with Madam
* White noise covariance matrices `wcov.fits`
* Original hitmaps from Madam (less detectors, lower sampling rate) and corrected hitmaps representative of nominal focal plane

NERSC

`/global/cscratch1/sd/zonca/pico/full_focal_plane_noise`

tape

`~zonca/pico/201806_sparse_focal_plane_noise`
