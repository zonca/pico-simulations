#!/usr/bin/env python3
# -*- encoding: utf-8 -*-

"""This script joins FITS files containing the gain solutions found by DaCapo
into one FITS file suitable to be read by TOAST."""

import os
import sys
import numpy as np
from astropy.io import fits


def main(args):
    if len(args) < 4 or len(args) % 2 != 0:
        print("Usage: {0} GAIN_FILE1 DETNAME1 [GAIN_FILE2 DETNAME2...] OUTPUT_FILE"
              .format(os.path.basename(args[0])))
        sys.exit(1)

    outputfilename = args[-1]
    filedetpairs = args[1:-1]

    inputfiles = filedetpairs[::2]
    detectors = filedetpairs[1::2]

    hdus = [
        fits.PrimaryHDU(),
        fits.BinTableHDU.from_columns([
            fits.Column(name='NAME', array=detectors, unit='',
                        format='{0}A'.format(max([len(x) for x in detectors]))),
        ]),
    ]
    hdus[1].header["EXTNAME"] = "DETECTORS"

    timewritten = False
    timecolumn = None
    gaincolumns = None
    for detidx, curinputfile, curdet in zip(range(len(detectors)), inputfiles, detectors):
        try:
            print('Reading file "{0}"...'.format(curinputfile))
            with fits.open(curinputfile) as inpf:
                gains = inpf['GAINS'].data.field('GAIN')
                gainn = inpf['GAINS'].data.field('NSAMPLES')
                ofsn = inpf['OFFSETS'].data.field('NSAMPLES')
                ofsperiod = inpf['PERIODS'].header['LENGTH']
        except FileNotFoundError:
            print('File "{0}" not found'.format(curinputfile), file=sys.stderr)
            sys.exit(1)

        if ofsperiod == 0.0:
            ofsperiod = 30.0

        ofsstarttime = np.arange(len(ofsn)) * ofsperiod
        gainstarttime = np.empty(len(gains), dtype='float')
        samplesincurgain = 0
        gainidx = 0
        for ofsidx in range(len(ofsn)):
            if samplesincurgain == 0:
                gainstarttime[gainidx] = ofsstarttime[ofsidx]

            samplesincurgain += ofsn[ofsidx]

            if samplesincurgain == gainn[gainidx]:
                samplesincurgain = 0
                gainidx += 1

        if not timewritten:
            cur_hdu = fits.BinTableHDU.from_columns([
                fits.Column(name='TIME', array=gainstarttime,
                            unit='s', format='1D'),
            ])
            cur_hdu.header["EXTNAME"] = "TIMINGS"
            hdus.append(cur_hdu)
            timecolumn = gainstarttime
            timewritten = True
        else:
            assert len(timecolumn) == len(gainstarttime), \
                "Error: the number of gain factors is different among detectors"
            assert np.allclose(timecolumn, gainstarttime), \
                "Error: the time of gain samples is inconsistent among detectors"

        if gaincolumns is None:
            gaincolumns = gains
        else:
            gaincolumns = np.c_[gaincolumns, gains]

    gainhdu = fits.ImageHDU(gaincolumns)
    gainhdu.header["EXTNAME"] = "GAINS"
    hdus.append(gainhdu)
    fits.HDUList(hdus).writeto(outputfilename, overwrite=True)

    print('File {0} written'.format(outputfilename))


if __name__ == '__main__':
    main(sys.argv)
