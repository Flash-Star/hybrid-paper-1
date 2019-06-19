from collections import OrderedDict
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from CustomScatterplot import CustomScatterplot
from matplotlib import rc
from scipy.optimize import curve_fit

annotation_font_size = 18

# CHECK ORDERING OF FIT

intdataname_brendan = 'ini_fin_integrals_co_rhoddt-7.2.dat'
intdataname_cone = 'ini_fin_integrals_cone.dat'

intsini_brendan = OrderedDict([])
intsfin_brendan = OrderedDict([])
intsini_cone = OrderedDict([])
intsfin_cone = OrderedDict([])

# get headers
def readintfile(f,intsini,intsfin):
	ncols = 0
	cols = []
	gotCols = False
	while (True):
		l = fint.readline()
		if not l:
			break
		if (l=='----------\n'):
			h = fint.readline()
			if (not gotCols):
				ncols = 0
				hs = h.rstrip('\n').split('  ')
				for hi in hs:
					if (hi != ''):
						cols.append(hi)	
						ncols = ncols + 1
				# prepare column data structures
				for c in cols:
					if not c in intsini:
						intsini[c] = []
					if not c in intsfin:
						intsfin[c] = []
				gotCols = True
			# read first and last data point
			row = fint.readline()
			srow = row.split()
			for i in range(0,ncols):
				intsini[cols[i]].append(srow[i])
			row = fint.readline()
			srow = row.split()
			for i in range(0,ncols):
				intsfin[cols[i]].append(srow[i])

# Read the data from the integral files
fint = open(intdataname_brendan,'r')
readintfile(fint,intsini_brendan,intsfin_brendan)
fint.close()
nentries_brendan = len(intsini_brendan['mass burned'])
print 'N_brendan: ' + str(nentries_brendan)
fint = open(intdataname_cone,'r')
readintfile(fint,intsini_cone,intsfin_cone)
fint.close()
nentries_cone = len(intsini_cone['mass burned'])
print 'N_cone: ' + str(nentries_cone)

def reorganize_data(intsini, intsfin, data_ini, data_fin):
        # Reorganize the data into a single dictionary for plotting ease
        # Convert strings to numbers
        data_ini = OrderedDict([])
        data_fin = OrderedDict([])
        headers = intsini.keys()
        for h in headers:
	        print 'h: ' + str(h) + ', leni: ' + str(len(intsini[h])) + ', lenf: ' + str(len(intsfin[h]))

        for h in headers:
	        data_ini[h] = np.array([float(s) for s in intsini[h]])
	        data_fin[h] = np.array([float(s) for s in intsfin[h]])

        # Put masses in units of Msun
        gpermsun = 1.988435e33 # grams/Msun
        for h in headers:
	        if h.find('mass') != -1:
		        data_ini[h] = data_ini[h]/gpermsun
		        data_fin[h] = data_fin[h]/gpermsun

        return (data_ini, data_fin)

data_ini_brendan = OrderedDict([])
data_fin_brendan = OrderedDict([])
data_ini_brendan, data_fin_brendan = reorganize_data(intsini_brendan, intsfin_brendan, data_ini_brendan, data_fin_brendan)
data_ini_cone = OrderedDict([])
data_fin_cone = OrderedDict([])
data_ini_cone, data_fin_cone = reorganize_data(intsini_cone, intsfin_cone, data_ini_cone, data_fin_cone)

# List headers for cone
print data_ini_cone.keys()
print data_fin_cone.keys()

# Declare stuff necessary for linear fitting
def linearfun(x,m,b):
        return m*x+b

# # Parameter study for cone
# Compare Ni-56 production with ignition amplitude 'ign_amp'
plt.figure()
fig = plt.gcf()
ax = fig.add_subplot(111)
ax.plot(data_fin_cone['ign_amp']/1.0e5, data_fin_cone['estimated Ni56 mass'], '.b')
plt.xlabel('Ignition Amplitude ($\\mathrm{\\times 10^5}$)')
plt.ylabel('Estimated $^{56}$Ni Mass ($\mathrm{M_\odot}$)')
plt.tight_layout()
plt.savefig('ni56_ign-amp_scatter.eps')
plt.clf()

# Compare Ni-56 production with initial burned mass 'mass burned'
## Perform fit
lopt_cone, lcov_cone = curve_fit(linearfun, data_ini_cone['mass burned'], data_fin_cone['estimated Ni56 mass'])
lerr_cone = np.sqrt(np.diag(lcov_cone))
bmass_fit_cone = np.linspace(min(data_ini_cone['mass burned']), max(data_ini_cone['mass burned']), 100)
ni56_fit_cone = bmass_fit_cone*lopt_cone[0] + lopt_cone[1]
print 'Ni56 vs Init. Burned Mass, CO: m = ' + str(lopt_cone[0]) + ', b = ' + str(lopt_cone[1])

## Plot
plt.figure()
fig = plt.gcf()
ax = fig.add_subplot(111)
ax.plot(bmass_fit_cone, ni56_fit_cone, linestyle='-', color='blue', alpha=0.9, linewidth=2.0)
ax.plot(data_ini_cone['mass burned'], data_fin_cone['estimated Ni56 mass'], color='green',marker='D', markersize=5, linestyle='None', label='CONe Realizations')
ax.plot(data_ini_brendan['mass burned'], data_fin_brendan['estimated Ni56 mass'], color='red',marker='o', markersize=5, linestyle='None', label='CO Realizations')
mlco = mlines.Line2D([],[],color='red',marker='o', markersize=5, linestyle='None', label='CO Realizations')
mlcone = mlines.Line2D([],[],color='green',marker='D', markersize=5, linestyle='None', label='CONe Realizations')
mlcone_fit = mlines.Line2D([],[],color='blue',linestyle='-',linewidth=2.0,label='CONe Linear Fit\n' +
                           'Slope: ' + '{0:0.2f}'.format(lopt_cone[0]) + r'$\pm$' + '{0:0.2f}'.format(lerr_cone[0]) + '\n' +
                           'Intercept: ' + '{0:0.2f}'.format(lopt_cone[1]) + r'$\pm$' + '{0:0.2f}'.format(lerr_cone[1]))
plt.legend(handles=[mlco, mlcone,mlcone_fit],loc=1,borderpad=0.2, borderaxespad=0.0,
           handletextpad=0.0, prop={'size':annotation_font_size})
plt.xlabel('Initial Burned Mass ($\mathrm{M_\odot}$)')
plt.ylabel('Estimated $^{56}$Ni Mass ($\mathrm{M_\odot}$)')
plt.tight_layout()
plt.savefig('ni56_initial-burned-mass_scatter.eps')
plt.clf()

# Compare Ni-56 production with mpole number 'mpoles'
plt.figure()
fig = plt.gcf()
ax = fig.add_subplot(111)
ax.plot(data_fin_cone['mpoles']/2, data_fin_cone['estimated Ni56 mass'], color='green',marker='D', markersize=5, linestyle='None')
mlcone = mlines.Line2D([],[],color='green',marker='D', markersize=5, linestyle='None', label='CONe Realizations')
plt.legend(handles=[mlcone],loc=1,borderpad=0.2, borderaxespad=0.0,
           handletextpad=0.0, prop={'size':annotation_font_size})
ax.set_xlim([0, 11])
plt.xlabel('Number of Initially Burned Regions')
plt.ylabel('Estimated $^{56}$Ni Mass ($\mathrm{M_\odot}$)')
plt.tight_layout()
plt.savefig('ni56_mpoles_scatter.eps')
plt.clf()
