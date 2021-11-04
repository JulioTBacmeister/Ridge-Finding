
   f=addfile("test.nc","rw")
; Add long names and units:
;  MXDIS ---
   var=f->MXDIS
   var@long_name="Obstacle Height"
   var@units="m"
   f->MXDIS=var

;  CLNGT ---
   var=f->CLNGT
   var@long_name="Ridge Length estimate"
   var@units="km"
   f->CLNGT=var

;  HWDTH ---
   var=f->HWDTH
   var@long_name="Ridge Width estimate"
   var@units="km"
   f->HWDTH=var

;  ANGLL ---
   var=f->ANGLL
   var@long_name="Ridge Orientation angle; clockwise from N-S in lat-lon frame"
   var@units="degrees (0-180)"
   f->ANGLL=var

;  ANGLX ---
   var=f->ANGLX
   var@long_name="Ridge Orientation angle; clockwise from beta-axis in alpha-beta frame"
   var@units="degrees (0-180)"
   f->ANGLX=var

;  GBXAR ---
   var2=f->GBXAR
   var2@long_name="Grid cell area"
   var2@units="Steradians"
   f->GBXAR=var2
