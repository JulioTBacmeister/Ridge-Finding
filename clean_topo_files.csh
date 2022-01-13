#!/bin/tcsh

# Assumes you are in the 'case' directory
#----------------------------------------------------------------------------------
set n = 1
set ogrid = "$argv[$n]"

cd output
set foo=`ls -1t ${ogrid}*.nc`
cd ..
echo $foo[1]


mkdir -p cleaned

#---------------------------------------------------------------------------------
# Dec 2021
# This needs to be devleoped, but here at least is the right ncks command.
# Apparently it is OK to remove variables that aren't in the file.


ncks -x -v ISOWD,ISOHT,ISOWDQ,ISOHTQ,WGHTS,ANGLX,MXVRX,MXVRY,SGH_UF,TERR_UF,FALLQ,RISEQ,COUNT,CWGHT  output/$foo[1] cleaned/$foo[1]

exit 0
