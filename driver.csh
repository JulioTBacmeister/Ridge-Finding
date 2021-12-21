#!/bin/tcsh

set ogrid = 'fv_0.9x1.25'
set case  = 'v3_x01'
#set band  = {'high_pass' 'beta','gamma'}
set band  = 'high_pass'

# Set some defaults
if ( $ogrid == 'geos_fv_c48' ) then
endif
if ( $ogrid == 'geos_fv_c90' ) then
   set Co=48
   set Fi=1
   set Nsw=34
endif
if ( $ogrid == 'geos_fv_c180' ) then
   set Co=32
   set Fi=1
   set Nsw=22
endif
if ( $ogrid == 'geos_fv_c360' ) then
   set Co=16
   set Fi=1
   set Nsw=12
endif
if ( $ogrid == 'geos_fv_c720' ) then
   set Co=8
   set Fi=1
   set Nsw=6
endif

if ( $band == 'high_pass' ) then 
#all bands passed
if ( $ogrid == 'fv_0.9x1.25' ) then
   set Co=60
   set Fi=1
   set Nsw=42
endif
endif
if ( $band == 'beta' ) then 
#band passed "meso-beta"
if ( $ogrid == 'fv_0.9x1.25' ) then
   set Co=60
   set Fi=8
   set Nsw=42
endif
endif
if ( $band == 'gamma' ) then 
#high passed "meso-gamma"
if ( $ogrid == 'fv_0.9x1.25' ) then
   set Co=14
   set Fi=1
   set Nsw=10
endif
endif


echo "Running band="$band
echo "Coarse radius="$Co
echo "fine radius="$Fi
echo "output grid="$ogrid

touch ../$case/"Doing_this__Co"$Co"_Fi"$Fi"_Nsw"$Nsw"_grid"$ogrid

./create_topo.csh $ogrid $Co $Fi $Nsw $case


exit
