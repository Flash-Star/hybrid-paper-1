#!/bin/bash
#PBS -l nodes=[number of compute nodes]:ppn=[processors per node],walltime=[hh:mm:ss, job will not exceed this time]
#PBS -q [queue name, e.g. large, medium, long, short for IACS Handy]
#PBS -N [job name as it will appear in the queue]

# Reference for IACS Handy Queues
# Currently each node has 16 cores, so max ppn is ppn=16.
# large : 16 max nodes, 6:00:00 max walltime
# medium: 8 max nodes, 12:00:00 max walltime
# long  : 4 max nodes, 24:00:00 max walltime
# short : 4 max nodes, 00:15:00 max walltime

cd "[full path to executable]"

mpiexec ./executable # Note that you don't specify number of processors using -np.

