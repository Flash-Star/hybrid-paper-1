# Run only legs 2 and 3, assuming leg 1 has already been run

FPARS=Townsley_2d-DDT_flashpars_cone_shell

#nominal ignMPoleAmp is 24e5, so I'm going to see how the results scale with this, running at 25%, 50%, 150%, 200%, and 250%
#for impa in 6 12 36 48 60
for impa in 24
do
 da="ignMPoleA-"$impa"e5"
# mkdir $da # comment out if the directory exists already
 for mp in 4 6 8
# for mp in 14 16 
# for mp in 4
 do
  d=mpole-$mp
  # These directories exist already
  #mkdir $d
  #mkdir all_legs
  datpre="profile75_mpole-"$mp"_r-35e6_a-"$impa"e5"
  # Do all legs
  echo "Starting impa-"$impa", mpole-"$mp | mailx -s "Handy Run Update 24/11/2014" eugene.willcox@gmail.com
  cp $da/$d/detpoints.dat .
  for l in 2 3
  do
   dl=leg$l
   # Copy some files
   cp $da/$d/$datpre".dat" $da/$d/leg1/.
   cp $da/$d/$datpre".dat" .
   # Remove existing leg directory
   rm -rf $da/$d/$dl
   mkdir $dl
   sed -r -b 's/(basenm[ ]*=).*/\1 "'$datpre'_"/g' < $FPARS/flash.par_leg$l | \
   sed -r -b 's/(r_match[ ]*=).*/\1 35.0e6/g' | sed -r 's/(ignMPoleA[ ]*=).*/\1 '$impa'.0e5/g' | \
   sed -r -b 's/(ignMPoleMinL[ ]*=).*/\1 '$mp'/g' | sed -r 's/(ignMPoleMaxL[ ]*=).*/\1 '$((mp+1))'/g' > f.p
   # Get rid of the trailing  on unmodified lines
   sed 's///' < f.p > flash.par
   rm f.p 
   # Copy the necessary checkpoint file to the current directory
   if [[ $l == 2 ]]
   then
    cfnum=16
    cfnam=$datpre"_hdf5_chk_00"$cfnum
    cp $da/$d/leg1/$cfnam .
   elif [[ $l == 3 ]]
   then
    cfnum=22
    cfnam=$datpre"_hdf5_chk_00"$cfnum
    cp $da/$d/leg2/$cfnam .
   fi
   mpiexec -np 32 ./flash4
   #touch "test_hdf5_leg"$l
   mv *hdf5* $dl/.
   mv flash.par $dl/.
   mv $datpre".log" $dl/.
   cp $datpre".dat" $da/$d/.
   mv $datpre".dat" $dl/.
   mv $dl $da/$d/.
   pushd $da/$d/all_legs
   cp -sf ../$dl/*hdf5* .
   popd
  done
  echo "Finished impa-"$impa", mpole-"$mp | mailx -s "Handy Run Update 24/11/2014" eugene.willcox@gmail.com
  mv detpoints.dat $da/$d/.
 done
done
