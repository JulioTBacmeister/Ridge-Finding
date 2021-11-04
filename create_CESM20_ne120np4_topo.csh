#!/bin/csh -f

cd /project/amp/juliob/Topo-generate-devel/Topo/cube_to_target-creates-CESM2.0-topo/

gmake clean
gmake

cp namelists/cube_to_target.nl_ne120np4_nc3000_Nsw010_Nrs002_Co015_Fi001 cube_to_target.nl

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



exit
