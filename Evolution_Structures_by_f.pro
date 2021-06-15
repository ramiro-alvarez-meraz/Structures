Pro Evolution_Structures_by_f

  f=100                           ;Accretion parameter
  nPlanets_=4                    ;Number of planets
  if f eq 1 then outputs=350	;The outputs
  if f eq 10 then outputs=450
  if f eq 100 then outputs=1000

  time=1000*findgen(outputs+1)                 ;Time
  Structure_Number_by_f=dblarr(nPlanets_-1,outputs+1)
  
  for nPlanets=2,nPlanets_ do begin
;Read the correct out
  if f eq 1 and nPlanets eq 2 then out=8
  if f eq 1 and nPlanets eq 3 then out=10
;  if f eq 1 and nPlanets eq 4 then out=11
  if f eq 1 and nPlanets eq 4 then out=18
  if f eq 10 and nPlanets eq 2 then out=14
  if f eq 10 and nPlanets eq 3 then out=12
  if f eq 10 and nPlanets eq 4 then out=13
  if f eq 100 and nPlanets eq 2 then out=9
;  if f eq 100 and nPlanets eq 3 then out=16
  if f eq 100 and nPlanets eq 3 then out=19
;  if f eq 100 and nPlanets eq 4 then out=17
  if f eq 100 and nPlanets eq 4 then out=20

  DataFolder='~/Dropbox/visualization_tools/images/StructuresEvolution/f'+string(f)+'_p'+string(nPlanets)
  TimeVsStructures=dblarr(2,outputs+1)
  TimeVsStructures_=strcompress(dataFolder+'/TimeVsStructures.dat',/remove_all)
  openr,1,TimeVsStructures_
  readf,1,TimeVsStructures
  close,1 
  Structure_Number_by_f(nPlanets-2,*)=TimeVsStructures(1,*)
  endfor

  FolderToDischargeThisImage='~/Dropbox/visualization_tools/images/StructuresEvolution'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,0
  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24

  plot,time,Structure_Number_by_f(0,*),$
       background=255,color=0,ytitle='# Structures',ytickinterval=5,$
       yrange=[0.5,30],psym=5,xstyle=1,ystyle=1,xtitle='time (years)',charsize=1.5,xtickinterval=300000


  if f eq 1 then begin
    x_axis=dblarr(1)
    x_axis[0]=185000.
  endif
  if f eq 10 then begin
    x_axis=dblarr(1)
    x_axis[0]=250000.
  endif
  if f eq 100 then begin
    x_axis=dblarr(1)
    x_axis[0]=540000.
  endif
  triangle_symbol=dblarr(1)
  triangle_symbol[0]=29.
  square_symbol=dblarr(1)
  square_symbol[0]=27.7
  cross_symbol=dblarr(1)
  cross_symbol[0]=26.5
   ;Returning to the old color table
    device,get_decompose=old_decomposed,decomposed=0
    loadct,39
  oplot,time,Structure_Number_by_f(0,*),psym=5,color=70,thick=2
  oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,390,540,'2 planets',charsize=1.5,charthick=2,color=70,/device
   ;Returning to the old color table
    device,get_decompose=old_decomposed,decomposed=0
    loadct,9
  oplot,time,Structure_Number_by_f(1,*),psym=6,color=160,thick=2
  oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,390,520,'3 planets',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,time,Structure_Number_by_f(2,*),psym=7,color=250,thick=2
  oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,390,500,'4 planets',charsize=1.5,charthick=2,color=250,/device

  write_png,strcompress(FolderToDischargeThisImage+'/Time_StructuresNumber_f'+string(f)+'.png',/remove_all),tvrd(0,0,600,600,0,true=1)


  RETURN
end

