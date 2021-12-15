#!/bin/tcsh

# Assumes you are in the right directory, i.e, the one with F90 files and namelists
#----------------------------------------------------------------------------------
mkdir -p output
mkdir -p output/raw
mkdir -p output/clean

module load compiler/gnu/default

gmake clean
gmake

#cp namelists/cube_to_target.nl_fv_0.9x1.25_nc3000_Nsw042_Nrs008_Co060_Fi008  cube_to_target.nl

set ogrid='fv_0.9x1.25'
set Co=60
set Fi=8
set Nsw=42
set Nrs=8

# Create starting namelist cube_to_target.nl
#---------------------------------------------
echo "&topoparams " > cube_to_target.nl
echo "  grid_descriptor_fname           = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/grid-descriptor-file/fv_0.9x1.25.nc' " >> cube_to_target.nl
echo "  output_grid                     = '${ogrid}'  " >> cube_to_target.nl
echo "  intermediate_cubed_sphere_fname = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/cubed-sphere-topo/gmted2010_modis-ncube3000-stitch.nc' " >> cube_to_target.nl
echo "  output_fname                    = 'junk' " >> cube_to_target.nl
echo "  externally_smoothed_topo_file   = 'junk' " >> cube_to_target.nl
echo "  lsmooth_terr = .false. " >> cube_to_target.nl
echo "  lexternal_smooth_terr = .false. " >> cube_to_target.nl
echo "  lzero_out_ocean_point_phis = .false. " >> cube_to_target.nl
echo "  lzero_negative_peaks = .true. " >> cube_to_target.nl
echo "  lsmooth_on_cubed_sphere = .true. " >> cube_to_target.nl
echo "  ncube_sph_smooth_coarse = ${Co} " >> cube_to_target.nl
echo "  ncube_sph_smooth_fine = ${Fi} " >> cube_to_target.nl
echo "  ncube_sph_smooth_iter = 1 " >> cube_to_target.nl
echo "  lfind_ridges = .true. " >> cube_to_target.nl
echo "  lridgetiles = .false. " >> cube_to_target.nl
echo "  nwindow_halfwidth = ${Nsw} " >> cube_to_target.nl
echo "  nridge_subsample = ${Nrs} " >> cube_to_target.nl
echo "  lread_smooth_topofile = .true.  " >> cube_to_target.nl
echo "/ " >> cube_to_target.nl


#PHASE 1.0
# --- smooth topo w/ 60-point smoother
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp.nl
cp tmp.nl cube_to_target.nl
#./cube_to_target

#PHASE 1.1
# --- find ridges on 60-point deviations
# --- and map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp2.nl
cp tmp2.nl cube_to_target.nl
./cube_to_target


#skipping Greenland "edge roughening"

cd output
set foo=`ls -1t ${ogrid}*Co*${Co}_Fi*${Fi}*`
echo "now clean-up "${foo}
echo "now clean-up the LATEST "${foo[1]}


exit
