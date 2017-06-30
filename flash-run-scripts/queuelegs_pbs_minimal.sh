#!/bin/bash
#PBS -l nodes=8:ppn=16,walltime=12:00:00
#PBS -q medium
#PBS -N jobname

datpre="profile75_mpole-"$mp"_r-35e6_a-"$impa"e5"

cd "workingpath"

for l in 1 2 3
do
 if [[ $l == 2 ]]
 then
  cfnum=16
  cfnam=$datpre"_hdf5_chk_00"$cfnum
  cp leg1/$cfnam .
 elif [[ $l == 3 ]]
 then
  cfnum=22
  cfnam=$datpre"_hdf5_chk_00"$cfnum
  cp leg2/$cfnam .
 fi
 dl="leg"$l
 cp flash.par_leg$l flash.par
 mpiexec ./flash4
 mv *hdf5* $dl/.
 mv flash.par $dl/.
 mv $datpre".log" $dl/.
done

