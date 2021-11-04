pro enhance_sgh30_fv_2x2,dummy=d

soo2 = file_search( '../output/','fv_0.9x1.25_nc3000_NoAniso_Co008_Fi001*' )
soo1 = file_search( '../output/','fv_0.9x1.25_nc3000_Nsw042_Nrs008_Co060_Fi001*' )




fi2 = 'fv_1.9x2.5_nc3000_NoAniso_Co008_Fi001_20190318.nc'   ; soo2(0)  ;'../output/fv_0.9x1.25_nc3000_Nsw006_Nrs002_Co008_Fi001_ZR_test_vX_20161130_1207.nc'
fi1 = 'fv_1.9x2.5_nc3000_Nsw084_Nrs016_Co120_Fi001_ZR_061116.nc'   ; soo1(0)  ; 'fv_0.9x1.25_nc3000_Nsw042_Nrs008_Co060_Fi001_ZR_160505.nc'

print,' Replacing Greenland SGH30 in ... '
print,fi1
print,'  with SGH in .... '
print,fi2

rncvar,f=fi2,get='SGH',dat=sgh
rncvar,f=fi1 ,get='SGH30',dat=sgh30


sgh2 = SQRT( sgh^2 + sgh30^2 )

  skoo = strsplit( fi1 , '_',/ext )
  nskoo=n_elements(skoo)
  skoo(nskoo-1) = 'GRNL_'+skoo(nskoo-1)
  fo = strjoin( skoo, '_' )


STOP

  spawn,"cp "+fi1+' '+fo

  rncvar,f=fo ,get='LANDFRAC',dat=landf
  
  sgh30x = sgh30

  for j=158/2,185/2 do begin
     for i=235/2,278/2 do begin
        if landf(i,j) gt .1 then begin
           sgh30x(i,j)=sgh2(i,j)
        endif
     endfor
  endfor
  ; remove Iceland
  for j=162/2,167/2 do begin
     for i=267/2,278/2 do begin
        if landf(i,j) gt .1 then begin
           sgh30x(i,j)=sgh30(i,j)
        endif
     endfor
  endfor
  ; remove Baffin
  for j=157/2,168/2 do begin
     for i=232/2,240/2 do begin
        if landf(i,j) gt .1 then begin
           sgh30x(i,j)=sgh30(i,j)
        endif
     endfor
  endfor

  sgh2 = sgh30x

rncvar_replace,replace="SGH30",f=fo,data=sgh2

end



