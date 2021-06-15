  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,abs(SigmaSlopeHill(0,*)),background=255,$                            
       color=0,ytitle='Sigma Slope in 0.1-0.3 Radii Hill',psym=1,xstyle=1,ystyle=1,$
       xtitle='time (years)',charsize=1.5,xtickinterval=300000,yrange=[2.d-3,9.d0],/ylog
         fstring=strtrim(f,2)
  xyouts,150,530,'f='+fstring,charsize=1.5,color=0,/device
  xyouts,400,530,'Inner planet',charsize=1.5,color=0,/device
  oplot,time,abs(SigmaSlopeHill(1,*)),color=100,psym=1
  xyouts,400,500,'Outer planet',charsize=1.5,color=100,/device
  write_png,strcompress(dischargeImagesFolder+'/Time_SigmaSlopeHill.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

