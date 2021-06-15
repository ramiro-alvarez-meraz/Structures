  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,AccPlanet(0,*)/0.001,background=255,$                            
       color=0,ytitle='dM/dt  (M!LJ!N/year)',yrange=[1.e-8,9.e-4],psym=1,xstyle=1,ystyle=1,$
       xtitle='time (years)',charsize=1.5,/ylog,xtickinterval=1000000
         fstring=strtrim(f,2)
  xyouts,150,530,'f='+fstring,charsize=1.5,color=0,/device
  xyouts,150,500,'Planet 0',charsize=1.5,color=0,/device
  xyouts,400,530,'Onto planet',charsize=1.5,color=0,/device
  oplot,time,abs(AccMeanHillMinus(0,*)/0.001),color=100,psym=1
  xyouts,400,500,'Inside R!LHill!N',charsize=1.5,color=100,/device
  write_png,strcompress(dischargeImagesFolder+'/Time_PlanetAccHill.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

