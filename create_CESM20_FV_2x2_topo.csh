#!/bin/csh -f

cd /project/amp/juliob/Topo-generate-devel/Topo/cube_to_target-creates-CESM2.0-topo/

gmake clean
gmake

cp namelists/cube_to_target.nl_fv_1.9x2.5_nc3000_Nsw084_Nrs016_Co120_Fi001 cube_to_target.nl

#PHASE 1.0
# --- smooth topo w/ 60-point smoother
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp.nl
cp tmp.nl cube_to_target.nl
##./cube_to_target

#PHASE 1.1
# --- find ridges on 120-point deviations
# --- and map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp2.nl
###sed '/lfind_ridges/s/.true./.false./' < cube_to_target.nl > tmp2.nl
cp tmp2.nl cube_to_target.nl
##./cube_to_target

#PHASE 2.0
# --- smooth topo w/ 8-point smoother for 
# --- Greenland SGH30 adjustment
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp3.nl
cp tmp3.nl cube_to_target.nl
sed '/ncube_sph_smooth_coarse/s/120/8/' < cube_to_target.nl > tmp3.nl
cp tmp3.nl cube_to_target.nl
#./cube_to_target

#PHASE 2.1
# --- skip ridges but map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp4.nl
cp tmp4.nl cube_to_target.nl
sed '/lfind_ridges/s/.true./.false./' < cube_to_target.nl > tmp4.nl
cp tmp4.nl cube_to_target.nl
./cube_to_target


#PHASE 3.0
# --- Overwrite Greenland SGH30
#cd postproc
#idl <<EOF
#enhance_sgh30
#EOF


exit
