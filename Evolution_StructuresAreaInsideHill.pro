;  window,1,xsize=600,ysize=600
  Set_plot,'z'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  InnerPlanet=0
  OuterPlanet=nPlanets-1
  plot,time,ATauHill(0,1,*),background=255,$                            
       color=0,ytitle='Area inside 0.75R!IH!N ( UA!E2!N )',yrange=[0.01,99],psym=6,xstyle=1,$
;       color=0,ytitle='Area inside 0.75R!IH!N !L0.005-0.25 [!4l!Xm]!N ( UA!E2!N )',yrange=[0.01,99],psym=6,xstyle=1,$
       xtitle='time (years)',charsize=1.5,symsize=1.2,thick=2,/ylog,xtickinterval=300000,ytickinterval=2,ystyle=1
  f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  x_axis=dblarr(1)
  line_x=dblarr(2)
  solid_line=dblarr(2)
  dashed_line=dblarr(2)
if f eq 1 then begin
  x_axis[0]=185000.
  line_x[0]=175000.
  line_x[1]=195000.
  solid_line[0]=17.
  solid_line[1]=17.
  dashed_line[0]=9.
  dashed_line[1]=9.
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
triangle_symbol[0]=75.
square_symbol=dblarr(1)
square_symbol[0]=50.
cross_symbol=dblarr(1)
cross_symbol[0]=33.
  counter_temp=0
  for n=0,outputs do begin
    if ((ATau[0,n] ne 0.0) or (ATau[1,n] ne 0.0) or (ATau[2,n] ne 0.0)) then counter_temp+=1
  endfor
  time_temp=dblarr(counter_temp)
  totalAhill_temp=dblarr(counter_temp)
  innerPlanetHill_temp=dblarr(counter_temp)
  RatioAhilltoRealAhill=dblarr(counter_temp)
  counter_temp_new=0
  file=strcompress(dischargeImagesFolder+'Ratio_AtotalHill_to_RealHill.dat',/remove_all)
  openw,uni1,file,/get_lu
  for n=0,outputs do begin
    if ((ATauHill[0,0,n] ne 0.0) or (ATauHill[0,1,n] ne 0.0) or (ATauHill[0,2,n] ne 0.0)) then begin 
      time_temp[counter_temp_new]=time[n]
      totalAhill_temp[counter_temp_new]=ATauHill[0,0,n]+ATauHill[0,1,n]+ATauHill[0,2,n]
      innerPlanetHill_temp[counter_temp_new]=InnerPlanetHill[n]
      RatioAhilltoRealAhill[counter_temp_new]=totalAhill_temp[counter_temp_new]/(!PI*InnerPlanetHill[n]*InnerPlanetHill[n])
printf,uni1,time_temp[counter_temp_new],RatioAhilltoRealAhill[counter_temp_new],totalAhill_temp[counter_temp_new],!PI*InnerPlanetHill[n]*InnerPlanetHill[n],MassPlanet[0,n],InnerPlanetHill[n],InnerPlanetRadii[n],SemimajorAxis_InnerPlanet[n],total(CounterInsideHill(0,n,*)),counter_temp_new,format='(10f20.8)'
      counter_temp_new+=1
    endif
  endfor
  free_lun,uni1

print,counter_temp,'probe counter'
  xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
  xyouts,150,510,'Inner planet of',charsize=1.5,charthick=1,color=0,/device
  xyouts,150,490,numberPlanets+' planet system',charsize=1.5,charthick=1,color=0,/device
  if out eq 8 then xyouts,150,460,'((N!I!4u!N!3,N!Ir!N)=(384,256)',charsize=1.5,charthick=1,color=0,/device
  if out eq 50 then xyouts,150,460,'(N!I!4u!N!3,N!Ir!N)=(384,384)',charsize=1.5,charthick=1,color=0,/device
  if out eq 51 then xyouts,150,460,'(N!I!4u!N!3,N!Ir!N)=(448,384)',charsize=1.5,charthick=1,color=0,/device
  oplot,time,ATauHill(0,0,*),symsize=1.2,thick=2,color=70,psym=5
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,410,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
  oplot,time,ATauHill(0,1,*),symsize=1.2,thick=2,color=160,psym=6
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,410,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,time,ATauHill(0,2,*),symsize=1.2,thick=2,color=250,psym=7
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,410,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
;(MassTauHill(0,0,*)+MassTauHill(0,1,*)+MassTauHill(0,2,*))*0.005168*27068510.
;totalmasshill_temp=smooth(totalmasshill_temp,5,/edge_truncate)
oplot,time_temp,totalAhill_temp,linestyle=0,thick=2,color=0
;oplot,time,ATauHill(0,0,*)+ATauHill(0,1,*)+ATauHill(0,2,*),linestyle=2,thick=2,color=0
oplot,line_x,solid_line,color=0,thick=2
;  xyouts,410,465,'A!IInside Cells 0.75R!LH!N',charsize=1.5,charthick=1,color=0,/device
  xyouts,410,465,'A!Itotal!N',charsize=1.5,charthick=1,color=0,/device
;oplot,time,!PI*InnerPlanetHill(*)*InnerPlanetHill(*),linestyle=2,thick=2,color=0
oplot,time_temp,!PI*InnerPlanetHill_temp*InnerPlanetHill_temp,linestyle=2,thick=2,color=0
  xyouts,410,430,'!N!4p!3!N(R!LH!N)!E2!N',charsize=1.5,charthick=1,color=0,/device
oplot,line_x,dashed_line,color=0,thick=2,linestyle=2
;print,'Area prueba',totalAhill_temp
;print,'print inner Hill',3.1416*InnerPlanetHill[280]*InnerPlanetHill[280],3.1416*InnerPlanetHill[290]*InnerPlanetHill[290]
;  AXIS, yaxis=1,/ylog,yrange=[0.00001,99],$ 
;  YTITLE = 'Degrees Celsius',/save
  write_png,strcompress(dischargeImagesFolder+'/Time_AreaInsideHill.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)


  
