#!/bin/tcsh

set case='testing'
mkdir -p ../${case}/output
cp *.F90 ../${case}
cp Makefile ../${case}
cp -r analysis ../${case}

#cp output/topo_smooth* ../${case}/output/

cd /project/amp/juliob/Topo-generate-devel/Topo/smooth_topo/

set tops=`ls -1 *`

cd /project/amp/juliob/Topo-generate-devel/Topo/${case}

foreach foo ($tops)
   echo $foo
   ln -sf /project/amp/juliob/Topo-generate-devel/Topo/smooth_topo/${foo} output/${foo}
end


# Assumes you are in the right directory, i.e, the one with F90 files and namelists
#----------------------------------------------------------------------------------
mkdir -p output
mkdir -p output/raw
mkdir -p output/clean


module load compiler/gnu/default
gmake clean
gmake



set ogrid='fv_0.9x1.25'
set Co=60
set Fi=8
set Nsw=42

set Co=14
set Fi=1
set Nsw=10

# This is now used for all. Doesn't matter, will eliminate
set Nrs=00

if ( $ogrid == 'geos_fv_c48' ) then
   set scrip='PE48x288-CF.nc4'
endif
if ( $ogrid == 'geos_fv_c90' ) then
   set scrip='PE90x540-CF.nc4'
   set Co=48
   set Fi=1
   set Nsw=34
endif
if ( $ogrid == 'geos_fv_c180' ) then
   set scrip='PE180x1080-CF.nc4'
   set Co=32
   set Fi=1
   set Nsw=22
endif
if ( $ogrid == 'geos_fv_c360' ) then
   set scrip='PE360x2160-CF.nc4'
   set Co=16
   set Fi=1
   set Nsw=12
endif
if ( $ogrid == 'geos_fv_c720' ) then
   set scrip='PE720x4320-CF.nc4'
   set Co=8
   set Fi=1
   set Nsw=6
endif
if ( $ogrid == 'fv_0.9x1.25' ) then
   set scrip='fv_0.9x1.25.nc'
endif

# Create starting namelist cube_to_target.nl
#---------------------------------------------
echo "&topoparams " > cube_to_target.nl
echo "  grid_descriptor_fname           = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/grid-descriptor-file/${scrip}' " >> cube_to_target.nl
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

exit
cd output
set foo=`ls -1t ${ogrid}*Co*${Co}_Fi*${Fi}*`
echo "now clean-up "${foo}
echo "now clean-up the LATEST "${foo[1]}


exit
