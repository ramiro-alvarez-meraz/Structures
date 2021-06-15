  Set_plot,'z'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,(MeanDensityAtGap(0,*)+MeanDensityAtGap(1,*)+MeanDensityAtGap(2,*))*0.005168*2./2.25*1.e7,background=255,$                            
       color=0,ytitle='< !N!4R!3!N (g cm!E-2!N) >',yrange=[0.000001,1],psym=5,xstyle=1,ystyle=1,$
       xtitle='time (years)',charsize=1.5,/ylog,xtickinterval=300000,thick=2
         f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  xyouts,150,530,'f='+f,charsize=1.5,color=0,/device
  xyouts,150,500,numberPlanets+' planets',charsize=1.5,color=0,/device
  oplot,time,MeanDensityAtGap(0,*)*0.005168*2./2.25*1.e7,color=70,psym=1,thick=2
  xyouts,390,530,'       !4s!X < 0.5',charsize=1.5,color=70,/device
  oplot,time,MeanDensityAtGap(1,*)*0.005168*2./2.25*1.e7,color=160,psym=1,thick=2
  xyouts,390,500,'0.5 < !4s!X < 2.0',charsize=1.5,color=160,/device
  oplot,time,MeanDensityAtGap(2,*)*0.005168*2./2.25*1.e7,color=250,psym=1,thick=2
  xyouts,390,470,'2.0 < !4s!X',charsize=1.5,color=250,/device
  dustdensGapKraus=dblarr(outputs+1)
  dustdensGapKraus(*)=9.e-6
  oplot,time,dustdensGapKraus,color=0,linestyle=2, thick=2
  write_png,strcompress(dischargeImagesFolder+'/Time_MeanDensityAtGap.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

