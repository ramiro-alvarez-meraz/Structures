;  window,0,xsize=600,ysize=600
  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,Structure_Number(0,*),$
       background=255,color=0,ytitle='# Structures',ytickinterval=5,$
       yrange=[0.5,30],psym=1,xstyle=1,ystyle=1,xtitle='time (years)',charsize=1.5,xtickinterval=300000
  f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  xyouts,150,530,'f='+f,charsize=1.5,color=0,/device
  xyouts,150,500,numberPlanets+' planets',charsize=1.5,color=0,/device
  xyouts,390,530,'       !4s!X < 0.5',charsize=1.5,color=0,/device
  oplot,time,Structure_Number(1,*),$
        color=100,psym=1
  xyouts,390,500,'0.5 < !4s!X < 2.0',charsize=1.5,color=100,/device
  oplot,time,Structure_Number(2,*),$
        color=200,psym=1
  xyouts,390,470,'2.0 < !4s!X',charsize=1.5,color=200,/device
  oplot,time,Structure_Number(0,*)+Structure_Number(1,*)+Structure_Number(2,*),$
        color=0,psym=4
  write_png,strcompress(dischargeImagesFolder+'/Time_StructuresNumber.png',/remove_all),tvrd(0,0,600,600,0,true=1)


;   TmpFolder='~/Dropbox/visualization_tools/images/StructuresEmision/f'+string(f)+'_p'+string(nPlanets)+'/output'+string(output)
  TimeVsStructures=dblarr(2,outputs+1)
  openw,1,strcompress(dischargeImagesFolder+'/TimeVsStructures.dat',/remove_all)
  for i=0,outputs do begin
    printf,1,time(i),Structure_Number(0,i)+Structure_Number(1,i)+Structure_Number(2,i)
  endfor
  close,1

