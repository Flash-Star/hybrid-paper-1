FPARS=Townsley_2d-DDT_flashpars_cone_shell

# Do mpole-2,8,10,12
#for mp in 2 8 10 12
for mp in 0 4 6
do
 d=mpole-$mp
 mkdir $d
 mkdir all_legs
 datpre="profile75_mpole-"$mp"_r-35e6_a-24e5"
 # Do all legs
 echo "Starting mpole-"$mp | mailx -s "Handy Run Update 13/11/2014" eugene.willcox@gmail.com
 for l in 1 2 3
 do
  dl=leg$l
  mkdir $dl
  sed -r -b 's/(basenm[ ]*=).*/\1 "'$datpre'_"/g' < $FPARS/flash.par_leg$l | \
  sed -r -b 's/(r_match[ ]*=).*/\1 35.0e6/g' | sed -r 's/(ignMPoleA[ ]*=).*/\1 2.4e6/g' | \
  sed -r -b 's/(ignMPoleMinL[ ]*=).*/\1 '$mp'/g' | sed -r 's/(ignMPoleMaxL[ ]*=).*/\1 '$((mp+1))'/g' > f.p
  # Get rid of the trailing  on unmodified lines
  sed 's///' < f.p > flash.par
  rm f.p
  mpiexec -np 32 ./flash4
  #touch "test_hdf5_leg"$l
  mv *hdf5* $dl/.
  mv flash.par $dl/.
  mv $datpre".log" $dl/.
  pushd all_legs
  cp -sf ../$dl/*hdf5* .
  popd
  mv $dl $d/.
 done
 mv all_legs $d/.
 mv $datpre".dat" $d/.
 echo "Finished mpole-"$mp | mailx -s "Handy Run Update 13/11/2014" eugene.willcox@gmail.com
done


