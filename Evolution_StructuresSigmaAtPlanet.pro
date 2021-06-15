  Set_plot,'z'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,densAtPlanet(0,*),background=255,$                            
       color=0,ytitle='Sigma at planet location',yrange=[2.e-10,2.e-6],psym=1,xstyle=1,ystyle=1,$
       xtitle='time (years)',charsize=1.5,/ylog,xtickinterval=300000
         fstring=strtrim(f,2)
  xyouts,150,530,'f='+fstring,charsize=1.5,color=0,/device
  xyouts,330,530,'Planet #:',charsize=1.5,color=0,/device
  for np=0,nPlanets-1 do begin
  npString=strtrim(np+1,2)
  oplot,time,densAtPlanet(np,*),color=(np+1)*60,psym=1
  xyouts,400+((np+1)*30),530,npString,charsize=1.5,color=(np+1)*60,/device
  endfor
;  xyouts,400,500,'At Outer planet',charsize=1.5,color=0,/device
  write_png,strcompress(dischargeImagesFolder+'/Time_densAtPlanet.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)

