import glob
import os

fl = glob.glob('*.eps')

for f in fl:
        fb = f.rstrip('.eps')
        os.system('ps2pdf -dEPSCrop ' + f + ' ' + fb + '.pdf')
