import pysm
import sys
from pysm.nominal import models

import healpy as hp
import pandas as pd
import numpy as np

band = int(sys.argv[1])

det = pd.read_csv("pico.csv", delim_whitespace=True).set_index("Band").loc[band]

nside = 512

components_name = { n[0]:n for n in [
    'synchrotron',
    'dust',
    'freefree',
    'cmb',
    'ame',
] }

components = ["a2","d7","f1","s3"]

bandpass_low = det["Frequency"] - det["Bandwidth"]/2
bandpass_high = det["Frequency"] + det["Bandwidth"]/2
unit = 'uK_CMB'
instrument_bpass = {
    'use_smoothing' : True,
    'beams' : np.array([det["Beam_FWHM"]]),
    'nside' : nside,
    'add_noise' : False,
    'use_bandpass' : True,
    'channels' : [(np.linspace(bandpass_low, bandpass_high, 10), np.ones(10))],
    'output_units' : unit,
    'output_directory' : 'pysm_components',
    'output_prefix' : 'pico',
    'noise_seed' : 1234,
}

for c in components:

    full_name = components_name[c[0]]
    instrument_bpass['channel_names'] = [f'band_{band}_{full_name}_{unit}']
    sky_config = { full_name : models(c, nside=nside) }
    sky = pysm.Sky(sky_config)

    instrument = pysm.Instrument(instrument_bpass)
    instrument.observe(sky)
