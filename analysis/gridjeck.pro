pro gridjeck,xcase=xcase,fi=fi,co=co,nsw=nsw,nc=nc,ogrid=ogrid,quick=quick $
            ,rema=rema,fcam=fcam,topo=topo,grem=grem,tg=tg $
            ,cu=cu,latt=latt,lont=lont,itrgt=itrgt

 ;d='/project/amp/juliob/Topo-generate-devel/Topo/Ridge-Finding.git/output/'

if not keyword_set(xcase) then begin
   print,'Need xcase'
   stop
endif 
if not keyword_set(nc) then begin
   nc=3000L
endif 

if keyword_set(quick) then begin
   nc=3000L
   ogrid='fv_0.9x1.25'
   Co=60
   Fi=8
   Nsw=42
endif


fnames,xc=xcase,co=co,fi=fi,ns=nsw,og=ogrid,fcam=fcam,grem=grem,rema=rema,topo=topo,tg=tg

rdgrid,grem=grem,itrgt=itrgt
rncvar,f=tg,get='lon',dat=lont
rncvar,f=tg,get='lat',dat=latt
rdremap,rem=rema,top=topo,cube=cu

lont = reform( lont, nc , nc, 6)
latt = reform( latt, nc , nc, 6)



if ogrid eq 'fv_0.9x1.25' then begin

usoo=where( lont gt -130+360. and lont lt -70+360. and latt gt 25 and latt lt 55 )


oo=where( lont gt -110+360. and lont lt -100+360. and latt gt 37 and latt lt 42 )

ooo=where( latt gt 39.9 and latt lt 40.1 and lont gt 253.5 and lont lt 254.)
poo=where( itrgt eq 39948.0)  ; Front range

;IDL> help,poo
;POO             LONG      = Array[1330]
;IDL> oplot,lont(poo),latt(poo),ps=3
;IDL> print,lonm(230)
;       287.50000
;IDL> print,lonm(210)
;       262.50000
;IDL> print,lonm(200)
;       250.00000
;IDL> print,lonm(205)
;       256.25000
;IDL> print,lonm(203)
;       253.75000

endif

STOP
end
