; window,4,xsize=600,ysize=600
  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,Structures_Extern(0,*),background=255,$                            
       color=0,ytitle='# Structures > 180 UA',yrange=[0,5],psym=1,$
       xstyle=1,xtitle='time (years)',charsize=1.5,xtickinterval=150000
  f=strtrim(f,2)
  nPlanets=strtrim(nPlanets,2)
  xyouts,150,530,'f='+f,charsize=1.5,color=0,/device
  xyouts,150,500,nPlanets+' planets',charsize=1.5,color=0,/device
  xyouts,390,530,'      !4s!X < 0.5',charsize=1.5,color=0,/device
  oplot,time,Structures_Extern(1,*),color=100,psym=1
  xyouts,390,500,'0.5 < !4s!X < 2.0',charsize=1.5,color=100,/device
  oplot,time,Structures_Extern(2,*),color=200,psym=1
  xyouts,390,470,'2.0 < !4s!X',charsize=1.5,color=200,/device
  write_png,strcompress(dischargeImagesFolder+'/Time_ExternalStructures.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

