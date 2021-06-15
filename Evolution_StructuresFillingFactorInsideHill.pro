  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;To call the smooth function: smooth(MeanFillingFactorAtGap(0,*),10,/edge_truncate)
  plot,time,MeanFillingFactorAtHill(0,0,*),background=255,$                            
       color=0,ytitle='< filling factor Inside Hill Radii, f >',yrange=[1.0d-2,9.9],psym=1,xstyle=1,ystyle=1,$
       xtitle='time (years)',charsize=1.5,xtickinterval=300000,ytickinterval=10,thick=2,/ylog
         f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  xyouts,150,530,'f='+f,charsize=1.5,color=0,/device
  xyouts,150,500,'Planet 0',charsize=1.5,color=0,/device
  xyouts,390,530,'       !4s!X < 0.5',charsize=1.5,color=0,/device
  oplot,time,MeanFillingFactorAtHill(0,1,*),color=100,psym=1
  xyouts,390,500,'0.5 < !4s!X < 2.0',charsize=1.5,color=100,/device
  oplot,time,MeanFillingFactorAtHill(0,2,*),color=200,psym=1
  xyouts,390,470,'2.0 < !4s!X',charsize=1.5,color=200,/device
  write_png,strcompress(dischargeImagesFolder+'/Time_FillingFactorInsideHill.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)
