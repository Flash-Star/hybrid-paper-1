import glob
import os

fl = glob.glob('*.eps')

for f in fl:
	os.system('./epsprep.sh ' + f)
