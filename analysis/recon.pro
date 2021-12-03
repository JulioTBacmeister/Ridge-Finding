 d='/project/amp/juliob/Topo-generate-devel/Topo/Ridge-Finding.git/output/'

fn = 'remap_nc3000_Nsw042_Nrs008_Co060_Fi008_vX_'
soo=file_search( d+fn+'*.dat')
nsoo=n_elements(soo)
rem1=soo( nsoo -1 )

fn = 'topo_smooth_nc3000_Co060_Fi008'
soo=file_search( d+fn+'*.dat')
nsoo=n_elements(soo)
top1=soo( nsoo-1 )

fn = 'remap_nc3000_Nsw010_Nrs002_Co014_Fi001_vX_'
soo=file_search( d+fn+'*.dat')
nsoo=n_elements(soo)
rem2=soo( nsoo-1 )

fn = 'topo_smooth_nc3000_Co014_Fi001'
soo=file_search( d+fn+'*.dat')
nsoo=n_elements(soo)
top2=soo( nsoo-1 )


print,top1
print,rem1
print,top2
print,rem2

STOP

rdremap,rem=rem1,top=top1,cube=c1
rdremap,rem=rem2,top=top2,cube=c2


end
