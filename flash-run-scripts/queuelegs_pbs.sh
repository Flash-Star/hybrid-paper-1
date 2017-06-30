#!/bin/bash
#PBS -l nodes=8:ppn=16,walltime=12:00:00
#PBS -q medium
#PBS -N impa-6_mp-8
impa="6"
mp="8"
datpre="profile75_mpole-"$mp"_r-35e6_a-"$impa"e5"

cd "/gpfs/scratch/dwillcox/flash/hse/400k/mpoles/ignMPoleA-6e5/mpole-8_pbIgnRho-7.2"

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
 echo "Starting leg "$l" in ""impa-"$impa", mpole-"$mp | mailx -s "Handy Run Update 29/01/2014" eugene.willcox@gmail.com
 cp flash.par_leg$l flash.par
 mpiexec ./flash4
 mv *hdf5* $dl/.
 mv flash.par $dl/.
 mv $datpre".log" $dl/.
 echo "Finished impa-"$impa", mpole-"$mp | mailx -s "Handy Run Update 29/01/2014" eugene.willcox@gmail.com
done

