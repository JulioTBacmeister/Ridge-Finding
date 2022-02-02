#!/bin/tcsh



set case = "regress" 

mkdir -p ../${case}/output
cp *.F90 ../${case}
cp Makefile ../${case}
cp clean_topo_files.csh ../${case}
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

set ogrid = "ne30pg3"
set Co = "12"
set Fi = "1"
set Nsw = "8"



# This is now used for all. Doesn't matter, will eliminate
set Nrs=00


if ( $ogrid == 'ne30pg3' ) then
   set scrip='ne30pg3.nc'
endif


# Create starting namelist cube_to_target.nl
#---------------------------------------------
echo "&topoparams " > cube_to_target.nl
echo "  grid_descriptor_fname           = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/grid-descriptor-file/${scrip}' " >> cube_to_target.nl
echo "  output_grid                     = '${ogrid}'  " >> cube_to_target.nl
echo "  intermediate_cubed_sphere_fname = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/cubed-sphere-topo/gmted2010_bedmachine-ncube0540.nc' " >> cube_to_target.nl
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
# --- smooth topo w/ $Co-point smoother
sed '/lread_smooth_topofile/s/.true./.false./' < cube_to_target.nl > tmp.nl
cp tmp.nl cube_to_target.nl
./cube_to_target

#PHASE 1.1
# --- find ridges on $Co-point deviations
# --- and map to FV 1x1 grid
sed '/lread_smooth_topofile/s/.false./.true./' < cube_to_target.nl > tmp2.nl
cp tmp2.nl cube_to_target.nl
./cube_to_target


#skipping Greenland "edge roughening"
#echo "now clean-up the topo file"
#./clean_topo_files.csh $ogrid

exit
