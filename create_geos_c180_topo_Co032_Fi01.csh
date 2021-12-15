#!/bin/tcsh

# Assumes you are in the right directory, i.e, the one with F90 files and namelists
#----------------------------------------------------------------------------------
mkdir -p output
mkdir -p output/raw
mkdir -p output/clean


module load compiler/gnu/default

gmake clean
gmake

set ogrid='geos_fv_c180'

# Create starting namelist cube_to_target.nl
#---------------------------------------------
echo "&topoparams " > cube_to_target.nl
echo "  grid_descriptor_fname           = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/grid-descriptor-file/PE180x1080-CF.nc4' " >> cube_to_target.nl
echo "  output_grid                     = '${ogrid}'  " >> cube_to_target.nl
echo "  intermediate_cubed_sphere_fname = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/cubed-sphere-topo/gmted2010_modis-ncube3000-stitch.nc' " >> cube_to_target.nl
echo "  output_fname                    = 'junk' " >> cube_to_target.nl
echo "  externally_smoothed_topo_file   = 'junk' " >> cube_to_target.nl
echo "  lsmooth_terr = .false. " >> cube_to_target.nl
echo "  lexternal_smooth_terr = .false. " >> cube_to_target.nl
echo "  lzero_out_ocean_point_phis = .false. " >> cube_to_target.nl
echo "  lzero_negative_peaks = .true. " >> cube_to_target.nl
echo "  lsmooth_on_cubed_sphere = .true. " >> cube_to_target.nl
echo "  ncube_sph_smooth_coarse = 32 " >> cube_to_target.nl
echo "  ncube_sph_smooth_fine = 1 " >> cube_to_target.nl
echo "  ncube_sph_smooth_iter = 1 " >> cube_to_target.nl
echo "  lfind_ridges = .true. " >> cube_to_target.nl
echo "  lridgetiles = .false. " >> cube_to_target.nl
echo "  nwindow_halfwidth = 22 " >> cube_to_target.nl
echo "  nridge_subsample = 4 " >> cube_to_target.nl
echo "  lread_smooth_topofile = .true.  " >> cube_to_target.nl
echo "/ " >> cube_to_target.nl

#PHASE 1.0
# --- smooth topo w/ 14-point smoother
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp.nl
cp tmp.nl cube_to_target.nl
./cube_to_target

#PHASE 1.1
# --- find ridges on 14-point deviations
# --- and map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp2.nl
###sed '/lfind_ridges/s/.true./.false./' < cube_to_target.nl > tmp2.nl
cp tmp2.nl cube_to_target.nl
./cube_to_target

cd output

ls ${ogrid}*

set foo=`ls ${ogrid}*`
echo "now clean-up "${foo}
cp ${foo} raw/
ncks -x -v WGHTS,COUNT,CWGHT,FALLQ,RISEQ,MXVRX,MXVRY,SGH_UF,TERR_UF,ANGLX raw/${foo} clean/${foo}




exit
