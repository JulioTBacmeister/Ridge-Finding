#!/bin/tcsh

# Assumes you are in the right directory, i.e, the one with F90 files and namelists
#----------------------------------------------------------------------------------
mkdir -p output


module load compiler/gnu/default

gmake clean
gmake

cp namelists/cube_to_target.nl_fv_0.9x1.25_nc3000_Nsw042_Nrs008_Co060_Fi001  cube_to_target.nl

#PHASE 1.0
# --- smooth topo w/ 60-point smoother
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp.nl
cp tmp.nl cube_to_target.nl
./cube_to_target

#PHASE 1.1
# --- find ridges on 60-point deviations
# --- and map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp2.nl
###sed '/lfind_ridges/s/.true./.false./' < cube_to_target.nl > tmp2.nl
cp tmp2.nl cube_to_target.nl
./cube_to_target


#skipping Greenland "edge roughening"

exit

#PHASE 2.0
# --- smooth topo w/ 8-point smoother for 
# --- Greenland SGH30 adjustment
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp3.nl
cp tmp3.nl cube_to_target.nl
sed '/ncube_sph_smooth_coarse/s/60/8/' < cube_to_target.nl > tmp3.nl
cp tmp3.nl cube_to_target.nl
#./cube_to_target

#PHASE 2.1
# --- skip ridges but map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp4.nl
cp tmp4.nl cube_to_target.nl
sed '/lfind_ridges/s/.true./.false./' < cube_to_target.nl > tmp4.nl
cp tmp4.nl cube_to_target.nl
#./cube_to_target


#PHASE 3.0
# --- Overwrite Greenland SGH30
cd postproc
idl <<EOF
enhance_sgh30
EOF


exit
