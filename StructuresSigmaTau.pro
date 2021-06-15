;Define new palette of colors
  device,get_decompose=old_decomposed,decomposed=0
  loadct,3
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
;Radial density, radial acretion and radial space ratio:
;  window,8,xsize=600,ysize=600
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
  !P.MULTI = [0,1,1,0,0]
  plot,rad,2./2.25*1.e7*SigmaTau(*,0)/nsec,background=255,$                            
       color=0,xtitle='Radius ( AU )',yrange=[0.001,200.],linestyle=0,xstyle=1,ystyle=1,$
       ytitle='<  !N!4R!3!N (g cm!E-2!N)  >',charsize=1.5,/xlog,/ylog,thick=4
  f=strtrim(f,2)
  nPlanets=strtrim(nPlanets,2)
line_x=dblarr(2)
line_x[0]=10.
line_x[1]=15.
dot=dblarr(2)
dot[0]=125.
dot[1]=125.
dash=dblarr(2)
dash[0]=77.
dash[1]=77.
dash_dot=dblarr(2)
dash_dot[0]=45.
dash_dot[1]=45.
  xyouts,150,540,'f='+f,charsize=1.5,charthick=2,color=0,/device
  xyouts,150,520,nPlanets+' planets',charsize=1.5,charthick=2,color=0,/device
  xyouts,140,500,strcompress(string(ulong(output*1000.))+' years'),charsize=1.5,charthick=2,color=0,/device
  if out eq 52 then xyouts,150,480,'indirect term',charsize=1.5,charthick=1,color=0,/device
  oplot,rad,2./2.25*1.e7*SigmaTau(*,0)/nsec,color=70,linestyle=0,thick=4;psym=0
oplot,line_x,dot,color=70,thick=4,linestyle=0
  xyouts,390,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
  oplot,rad,2./2.25*1.e7*SigmaTau(*,1)/nsec,color=160,thick=4,linestyle=2
oplot,line_x,dash,color=160,thick=4,linestyle=2
  xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,rad,2./2.25*1.e7*SigmaTau(*,2)/nsec,color=250,thick=4,linestyle=3
oplot,line_x,dash_dot,color=250,thick=4,linestyle=3
  xyouts,390,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
  write_png,strcompress(dischargeImagesFolder+$
                        '/SigmaTau-SemiejeMayor.png',/remove_all),tvrd(0,0,600,600,0,true=1)
