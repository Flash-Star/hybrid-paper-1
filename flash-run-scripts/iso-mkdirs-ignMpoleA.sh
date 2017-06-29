FPARS=Townsley_2d-DDT_flashpars_cone_shell

#nominal ignMPoleAmp is 24e5, so I'm going to see how the results scale with this, running at 25%, 50%, 150%, 200%, and 250%
#for impa in 6 12 36 48 60
for impa in 12
do
 da="ignMPoleA-"$impa"e5"
 mkdir $da # comment out if the directory exists already
 cd $da
 for mp in 4 6 8
# for mp in 14 16 
 do
  d=mpole-$mp
  cp -r ~/codes/astro/flash/flashtemplate-cone-shell $d
  cd $d
  datpre="profile75_mpole-"$mp"_r-35e6_a-"$impa"e5"
  # Do all legs
  for l in 1 2 3
  do
   dl=leg$l
   mkdir $dl
   sed -r -b 's/(basenm[ ]*=).*/\1 "'$datpre'_"/g' < $FPARS/flash.par_leg$l | \
   sed -r -b 's/(r_match[ ]*=).*/\1 35.0e6/g' | sed -r 's/(ignMPoleA[ ]*=).*/\1 '$impa'.0e5/g' | \
   sed -r -b 's/(ignMPoleMinL[ ]*=).*/\1 '$mp'/g' | sed -r 's/(ignMPoleMaxL[ ]*=).*/\1 '$((mp+1))'/g' > f.p
   # Get rid of the trailing  on unmodified lines
   sed 's///' < f.p > flash.par_leg$l
   rm f.p 
  done
  cd ..
 done
 cd ..
done

