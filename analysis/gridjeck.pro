 ;d='/project/amp/juliob/Topo-generate-devel/Topo/Ridge-Finding.git/output/'

d='../output/'
nc=3000L
tg='/project/amp/juliob/Topo-generate-devel/Topo/inputdata/cubed-sphere-topo/gmted2010_modis-ncube3000-stitch.nc'
ogrid='fv_0.9x1.25'
Co=60
Fi=8
Nsw=42
Co$  = 'Co'+padstring(Co,/e2)
Fi$  = 'Fi'+padstring(Fi,/e2)
Nsw$ = 'Nsw'+padstring(Nsw,/e2)



;fn = 'remap_nc3000_Nsw042_Nrs008_Co060_Fi008_vX_'
fn = 'remap_nc3000_' + Nsw$ +'_Nrs000_' + Co$ + '_'+ Fi$ +'_vX_'
soo=file_search( d+fn+'*.dat')
nsoo=n_elements(soo)
rema=soo( nsoo -1 )

;fn = 'topo_smooth_nc3000_Co060_Fi008'
fn = 'topo_smooth_nc3000_' + Co$ + '_' + Fi$
soo=file_search( d+fn+'*.dat')
nsoo=n_elements(soo)
topo=soo( nsoo-1 )

grem =d+'grid_remap_nc3000_' + ogrid + '.dat'

; fv_0.9x1.25_nc3000_Nsw042_Nrs000_Co060_Fi008_20211222.nc
fn = ogrid + '_nc3000_'+Nsw$+'_Nrs000_'+Co$+'_'+Fi$+'_'

soo=file_search( d+fn+'*.nc')
nsoo=n_elements(soo)
fcam =soo( nsoo-1 )

print,tg
print,topo
print,rema
print,grem
print,fcam

STOP

rdgrid,grem=grem,itrgt=itrgt
rncvar,f=tg,get='lon',dat=lont
rncvar,f=tg,get='lat',dat=latt
rdremap,rem=rema,top=topo,cube=cu

lont = reform( lont, nc , nc, 6)
latt = reform( latt, nc , nc, 6)

STOP


oo=where( lont gt -110+360. and lont lt -100+360. and latt gt 37 and latt lt 42 )



hdp = fltarr( 120,120, 6)
hdb = fltarr( 120,120, 6)

for p=0,5 do begin

hdp(*,*,p)=histo_2d(  smoothxy( c1.dev(*,*,p)+c2.dev(*,*,p),3,3)  , smoothxy(c1.profi(*,*,p)+c2.profi(*,*,p),3,3),xmin=-2000,xmax=4000,ymin=-2000,ymax=4000,ybin=50,xbin=50,xvec=xv,yvec=yv)                                                                                                                                      
hdb(*,*,p)=histo_2d(  smoothxy( c1.dev(*,*,p)+c2.dev(*,*,p),3,3)  , smoothxy(c1.block(*,*,p)+c2.block(*,*,p),3,3),xmin=-2000,xmax=4000,ymin=-2000,ymax=4000,ybin=50,xbin=50,xvec=xv,yvec=yv)

endfor
end
