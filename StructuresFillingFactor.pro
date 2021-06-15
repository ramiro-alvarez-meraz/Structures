;  window,9,xsize=600,ysize=600
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
  plot,rad,Counter(*,0)/nsec,background=255,$                            
       color=0,xtitle='Semimajor axis (AU)',yrange=[-0.1,1.5],linestyle=1,xstyle=1,ystyle=1,$
       ytitle='Filling factor',charsize=1.5,/xlog,thick=1
  f=strtrim(f,2)
  nPlanets=strtrim(nPlanets,2)
  xyouts,150,540,'f='+f,charsize=1.5,charthick=2,color=0,/device
  xyouts,150,520,nPlanets+' planets',charsize=1.5,charthick=2,color=0,/device
  xyouts,140,500,strcompress(string(ulong(output*1000.))+' years'),charsize=1.5,color=0,charthick=2,/device
  oplot,rad,Counter(*,0)/nsec,color=70,linestyle=1,thick=2
oplot,line_x,dot,color=70,thick=3,linestyle=1
  xyouts,390,540,'!4s!X < 0.5',charsize=1.5,color=70,/device
  oplot,rad,Counter(*,1)/nsec,color=160,linestyle=2,thick=2
oplot,line_x,dash,color=160,thick=3,linestyle=2
  xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,color=160,/device
  oplot,rad,Counter(*,2)/nsec,color=250,linestyle=3,thick=2
oplot,line_x,dash_dot,color=250,thick=3,linestyle=3
  xyouts,390,500,'!4s!X > 2.0',charsize=1.5,color=250,/device
  TmpCounter=0
  FillingFactorAtGap=0
  for i=0,nrad-1 do begin
     if counter[i,2]/nsec lt 1 then begin
        Rad_fno1_ini=rad[i]
        break
     endif
  endfor
  for i=nrad-1,0,-1 do begin
     if counter[i,2]/nsec lt 1 then begin
        Rad_fno1_fin=rad[i]
        break
     endif
  endfor
catch,theError
if theError ne 0 then goto,jumpf

  print,Rad_fno1_ini,Rad_fno1_fin
;  for i=0,nrad do begin
;     if ((rad[i] ge Rad_fno1_ini) and (rad[i] le Rad_fno1_fin)) then begin
;        TmpCounter+=1
;        FillingFactorAtGap+=Counter[i,2]/nsec
;     endif
;  endfor
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
  for i=0,nrad do begin
     if ((rad[i] ge gapBorder[0]) and (rad[i] le gapBorder[1])) then begin
        TmpCounter+=1
        FillingFactorAtGap+=Counter[i,2]/nsec
     endif
  endfor
  MeanFillingFactorAtGap=FillingFactorAtGap/TmpCounter
  MeanFillingFactorGap=dblarr(nrad+1)
  for i=0,nrad do begin
     if (MeanFillingFactorAtGap gt 0) and ((rad[i] ge Rad_fno1_ini) and (rad[i] le Rad_fno1_fin)) then begin
        MeanFillingFactorGap[i]=MeanFillingFactorAtGap
     endif
  endfor
  if (MeanFillingFactorAtGap gt 0) then oplot,rad(*),MeanFillingFactorGap(*),color=250,linestyle=3,thick=4,max_value=1,min_value=0.0000001
jumpf:
  write_png,strcompress(dischargeImagesFolder+'/CellAzimTau-SemiejeMayor.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

