;  window,1,xsize=600,ysize=600
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;  !P.MULTI = [0,1,1,0,0]
  plot,time,MassTau(0,*)*0.005168*332946.,background=255,$                            
       color=0,ytitle='Dust mass in the gap [0.005-0.25!4l!Xm] ( M!L!20S!3!N )',yrange=[0.00001,99],psym=5,symsize=1.2,xstyle=1,$
       xtitle='time (years)',charsize=1.5,/ylog,xtickinterval=300000,ytickinterval=3,ystyle=1,thick=2,/YNOZERO
  f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
  xyouts,150,520,numberPlanets+' planets',charsize=1.5,charthick=1,color=0,/device
x_axis=dblarr(1)
if f eq 1 then begin 
  x_axis[0]=185000.
  triangle_symbol=dblarr(1)
  triangle_symbol[0]=55.
  square_symbol=dblarr(1)
  square_symbol[0]=28.
  cross_symbol=dblarr(1)
  cross_symbol[0]=14.
  line_x=dblarr(2)
  line_x[0]=170000.
  line_x[1]=200000.
endif
if f eq 10 then begin 
  x_axis[0]=250000.
  triangle_symbol=dblarr(1)
  triangle_symbol[0]=55.
  square_symbol=dblarr(1)
  square_symbol[0]=28.
  cross_symbol=dblarr(1)
  cross_symbol[0]=14.
  line_x=dblarr(2)
  line_x[0]=235000.
  line_x[1]=265000.
endif
if f eq 100 then begin 
  x_axis[0]=540000.
  triangle_symbol=dblarr(1)
  triangle_symbol[0]=55.
  square_symbol=dblarr(1)
  square_symbol[0]=28.
  cross_symbol=dblarr(1)
  cross_symbol[0]=14.
  line_x=dblarr(2)
  line_x[0]=510000.
  line_x[1]=570000.
endif
solid_line=dblarr(2)
solid_line[0]=8.
solid_line[1]=8.
dash=dblarr(2)
dash[0]=4.
dash[1]=4.
  oplot,time,MassTau(0,*)*0.005168*332946.,symsize=1.2,thick=2,color=70,psym=5
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,390,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
  oplot,time,MassTau(1,*)*0.005168*332946.,symsize=1.2,thick=2,color=160,psym=6
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,time,MassTau(2,*)*0.005168*332946.,symsize=1.2,thick=2,color=250,psym=7
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,390,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
  massKraus=dblarr(outputs+1)
  densKrausCGS=9.e-6
  densKrausAU=densKrausCGS/2.*2.25/1.e7			 ;*2./2.25*1.e7    =>    /2*2.25/1.e7
  massKraus(*)=densKrausAU*(Atau(0,*)+Atau(1,*)+Atau(2,*))*332946.
  counter_temp=0
  for n=0,outputs do begin
    if massKraus[n] ne 0.0 then counter_temp+=1
  endfor
  time_temp=dblarr(counter_temp)
  totalmass_temp=dblarr(counter_temp)
  massKraus_temp=dblarr(counter_temp)
  counter_temp_new=0
  for n=0,outputs do begin
    if massKraus[n] ne 0.0 then begin 
      time_temp[counter_temp_new]=time[n]
      totalmass_temp[counter_temp_new]=total(MassTau(*,n))
      massKraus_temp[counter_temp_new]=massKraus[n]
      counter_temp_new+=1
    endif
  endfor
print,counter_temp
;  print,massKraus(*)
;  oplot,time_temp,(MassTau(0,*)+MassTau(1,*)+MassTau(2,*))*0.005168*332946.,linestyle=0,thick=2,color=0
  oplot,time_temp,totalmass_temp*0.005168*332946.,linestyle=0,thick=2,color=0
oplot,line_x,solid_line,color=0,thick=2
;  xyouts,390,480,'M!Igap,total!N',charsize=1.5,charthick=1,color=0,/device
  xyouts,390,480,'Total',charsize=1.5,charthick=1,color=0,/device
  oplot,time_temp,massKraus_temp,color=0,thick=2,linestyle=2
oplot,line_x,dash,color=0,thick=2,linestyle=2
;  xyouts,390,460,'M!Igap,Kraus!N',charsize=1.5,charthick=1,color=0,/device
  xyouts,390,460,'Kraus',charsize=1.5,charthick=1,color=0,/device
;print,time,massKraus
  write_png,strcompress(dischargeImagesFolder+'/Time_TauMass.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)
  
