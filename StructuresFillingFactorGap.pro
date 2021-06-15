;  window,9,xsize=600,ysize=600
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
  plot,rad,Counter(*,0)/nsec,background=255,$                            
       color=0,xtitle='Semimajor axis (AU)',yrange=[3.0d-3,9.9],xstyle=1,ystyle=1,$
       ytitle='Filling factor',charsize=1.5,/xlog,/ylog,linestyle=0,thick=4
  f=strtrim(f,2)
  nPlanets=strtrim(nPlanets,2)
  xyouts,150,540,'f='+f,charsize=1.5,charthick=2,color=0,/device
  xyouts,150,520,nPlanets+' planets',charsize=1.5,charthick=2,color=0,/device
  xyouts,140,500,strcompress(string(ulong(output*1000.))+' years'),charthick=2,charsize=1.5,color=0,/device
  if out eq 52 then xyouts,150,480,'indirect term',charsize=1.5,charthick=1,color=0,/device
  oplot,rad,Counter(*,0)/nsec,color=70,linestyle=0,thick=4
line_x=dblarr(2)
line_x[0]=10.
line_x[1]=15.
dot=dblarr(2)
dot[0]=7.
dot[1]=7.
dash=dblarr(2)
dash[0]=5.3
dash[1]=5.3
dash_dot=dblarr(2)
dash_dot[0]=3.8
dash_dot[1]=3.8
oplot,line_x,dot,color=70,thick=4,linestyle=0
  xyouts,390,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
  oplot,rad,Counter(*,1)/nsec,color=160,linestyle=2,thick=4
oplot,line_x,dash,color=160,thick=4,linestyle=2
  xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,rad,Counter(*,2)/nsec,color=250,linestyle=3,thick=4
oplot,line_x,dash_dot,color=250,thick=4,linestyle=3
  xyouts,390,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Ciclos para calculo de densidad media
  densMed=dblarr(nrad)
  tot=dblarr(nrad)
  gapBorder=dblarr(2)
  for r=0,nrad-1 do begin
     tot[r]=0.0
     for l=0,nsec-1 do begin
        tot[r]=dens[l,r]+tot[r]
     endfor
  endfor
  for r=0,nrad-1 do begin
     densMed[r]=tot[r]/nsec
  endfor
  densCGSmed = densMed*2./2.25*1.e7
  tauMed=9.6*densCGSmed
  for r=nrad-1,0,-1 do begin
     if rad[r] lt Rplanet[0] then begin
        if tauMed[r] ge 2. then begin
           gapBorder[0]=rad[r]
           break
        endif
     endif
  endfor
  for r=0,nrad-1 do begin
     if rad[r] gt Rplanet[nPlanets-1] then begin
        if tauMed[r] ge 2. then begin
           gapBorder[1]=rad[r]
           break
        endif
     endif
  endfor
print,gapBorder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  MeanFillingFactorIntoGap=dblarr(TauRanges,nrad+1)
  for l=0,TauRanges-1 do begin
     for i=0,nrad do begin
;        if (rad[i] ge (Rplanet[0]-(2*HillPlanet[0]))) and (rad[i] le (Rplanet[nPlanets-1]+(2*HillPlanet[nPlanets-1]))) then begin
        if (rad[i] ge gapBorder[0]) and (rad[i] le gapBorder[1]) then begin
           MeanFillingFactorIntoGap[l,i]=MeanFillingFactorAtGap(l)
        endif
     endfor
  endfor

  oplot,rad(*),MeanFillingFactorIntoGap(2,*),color=250,linestyle=2,thick=4
  write_png,strcompress(dischargeImagesFolder+'/FillingFactor-SemiAxis.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

