pro colorado,cu=cu,lont=lont,latt=latt,w0=w0

if not keyword_set(w0) then w0=0
rex
window,re=2,xs=1100,ys=900,1 + w0

ploo=where( lont gt -110+360. and lont lt -100+360. and latt gt 36 and latt lt 43 )
lev=[1,100,200,500,800,1100+indgen(11)*300.]
wset,1+w0&amwgct&contour,cu.raw(ploo),lont(ploo),latt(ploo),/irr,lev=lev,c_colo=indgen(16),/fill,/xst,/yst
xyouts,/norm,.5,.95,align=0.5,"Raw Topo",size=2

;circlesym 
;oplot,[-105.1+360.],[40.16],ps=8,syms=2
;oplot,[-105.52+360.],[40.38],ps=8,syms=2

towns

lev=(findgen(16)-7.99)*200.
window,re=2,xs=1100,ys=900,2 + w0
wset,2+w0&amwgct&contour,cu.block(ploo),lont(ploo),latt(ploo),/irr,lev=lev,c_colo=indgen(16),/fill,/xst,/yst
xyouts,/norm,.5,.95,align=0.5,"Blocks",size=2
towns
window,re=2,xs=1100,ys=900,3 + w0
wset,3+w0&amwgct&contour,cu.dev(ploo),lont(ploo),latt(ploo),/irr,lev=lev,c_colo=indgen(16),/fill,/xst,/yst
xyouts,/norm,.5,.95,align=0.5,"Topo Dev",size=2
towns

STOP

return
end

pro towns

circlesym

oplot,[-105.1+360.],[40.16],ps=8,syms=2 ; Longmont
oplot,[-105.52+360.],[40.38],ps=8,syms=2 ; Estes Park
oplot,[-104.91+360.],[38.86],ps=8,syms=2 ; Manitou Springs
oplot,[-106.00+360.],[39.22],ps=8,syms=2 ; Fairplay
oplot,[-107.88+360.],[37.28],ps=8,syms=2 ; Durango
oplot,[-105.42+360.],[37.20],ps=8,syms=2 ; San Luis

circlesym,nv=4
oplot,[-108.12+360.],[39.44],ps=8,syms=2 ; Mt. Callahan

return

end
