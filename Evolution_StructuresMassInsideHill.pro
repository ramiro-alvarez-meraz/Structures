;  window,1,xsize=600,ysize=600
  Set_plot,'z'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  InnerPlanet=0
  OuterPlanet=nPlanets-1
  plot,time,MassTauHill(0,1,*)*0.005168*27068510.,background=255,$                            
       color=0,ytitle='Dust mass [0.005-0.25!4l!Xm] !N<0.7R!IH !N( M!IL!N )',yrange=[0.00001,99],psym=6,xstyle=1,$
       xtitle='time (years)',charsize=1.5,symsize=1.2,thick=2,/ylog,xtickinterval=300000,ytickinterval=2,ystyle=1
  f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  x_axis=dblarr(1)
  line_x=dblarr(2)
  solid_line=dblarr(2)
if f eq 1 then begin
  x_axis[0]=185000.
  line_x[0]=170000.
  line_x[1]=200000.
  solid_line[0]=8.
  solid_line[1]=8.
endif
if f eq 10 then begin
  x_axis[0]=250000.
  line_x[0]=235000.
  line_x[1]=265000.
  solid_line[0]=8.
  solid_line[1]=8.
endif
if f eq 100 then begin
x_axis[0]=540000.
  line_x[0]=510000.
  line_x[1]=570000.
  solid_line[0]=8.
  solid_line[1]=8.
endif
triangle_symbol=dblarr(1)
triangle_symbol[0]=60.
square_symbol=dblarr(1)
square_symbol[0]=28.
cross_symbol=dblarr(1)
cross_symbol[0]=15.
  counter_temp=0
  for n=0,outputs do begin ;MassTau(2,*)
    if ((MassTau[0,n] ne 0.0) or (MassTau[1,n] ne 0.0) or (MassTau[2,n] ne 0.0)) then counter_temp+=1
  endfor
  time_temp=dblarr(counter_temp)
  totalmasshill_temp=dblarr(counter_temp)
  counter_temp_new=0
  for n=0,outputs do begin
    if ((massTauHill[0,0,n] ne 0.0) or (massTauHill[0,1,n] ne 0.0) or (massTauHill[0,2,n] ne 0.0)) then begin 
      time_temp[counter_temp_new]=time[n]
      totalmasshill_temp[counter_temp_new]=MassTauHill[0,0,n]+MassTauHill[0,1,n]+MassTauHill[0,2,n]
      counter_temp_new+=1
    endif
  endfor
print,counter_temp,'probe counter'
  xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
  xyouts,150,510,'Inner planet of',charsize=1.5,charthick=1,color=0,/device
  xyouts,150,490,numberPlanets+' planet system',charsize=1.5,charthick=1,color=0,/device
  oplot,time,MassTauHill(0,0,*)*0.005168*27068510.,symsize=1.2,thick=2,color=70,psym=5
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,390,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
  oplot,time,MassTauHill(0,1,*)*0.005168*27068510.,symsize=1.2,thick=2,color=160,psym=6
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,time,MassTauHill(0,2,*)*0.005168*27068510.,symsize=1.2,thick=2,color=250,psym=7
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,390,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
;(MassTauHill(0,0,*)+MassTauHill(0,1,*)+MassTauHill(0,2,*))*0.005168*27068510.
;totalmasshill_temp=smooth(totalmasshill_temp,5,/edge_truncate)
  oplot,time_temp,totalmasshill_temp*0.005168*27068510.,linestyle=0,thick=2,color=0
oplot,line_x,solid_line,color=0,thick=2
;  xyouts,390,480,'M!Itotal,R!LH!N',charsize=1.5,charthick=1,color=0,/device
  xyouts,390,480,'Total',charsize=1.5,charthick=1,color=0,/device
;  AXIS, yaxis=1,/ylog,yrange=[0.00001,99],$ 
;  YTITLE = 'Degrees Celsius',/save
  write_png,strcompress(dischargeImagesFolder+'/Time_MassInsideHill.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)
  
