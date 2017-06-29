import glob
import os

fl = glob.glob('*.eps')

for f in fl:
        fb = f[:-4]
        os.system('ps2pdf -dEPSCrop ' + f + ' ' + fb + '.pdf')
