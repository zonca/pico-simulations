Calibration simulation for PICO
===============================

## Detector

* 1 pixel from the 90GHz band, band 9 from <https://zzz.physics.umn.edu/ipsig/baseline> **V3.0**

## Sky Model

* PICO PySM model (a2,d7,f1,s3)
* unlensed scalar CMB (r=0) with an intrinsic dipole from `/project/projectdirs/pico/data/sky_00/ffp10_unlensed_scl_cmb_000_alm.fits`, zeroed the dipole alm, still 10 microK residual dipole

## Software version

* `toast` with a modification only to `toast_satellite_sim.py` to support writing a fits file per observation per channel: <https://github.com/zonca/toast/tree/pico_fits>  at `8fe71f8f9b8149cf8bd032e0acb01e6167feba03`
* `PySM` `0883c51ffede3741be442135702e3d8a5a59df61`
* `pico_simulations`: `baa7cd93ef6a08ffec75c4f331993d2490e9e6db`

## Outputs

Destriped map and fits files that include timelines, pointing, dipole and input sky signal

## Results

* 28 Feb 2018: 185 days simulation in `/global/cscratch1/sd/zonca/pico/cal_sims/185days/out_000/`
