import sys
import pickle
import toast.tod as tt
from toast.vis import set_backend                                                                                                   

focalplane_filename = sys.argv[1]
with open(focalplane_filename, "rb") as p:
    fp = pickle.load(p)

outfile = focalplane_filename.replace("pkl", "png")
set_backend()


fp_onlyquat = { det: each_fp["quat"] for det, each_fp in fp.items() }
tt.plot_focalplane(fp_onlyquat, 10.0, 10.0, outfile)
