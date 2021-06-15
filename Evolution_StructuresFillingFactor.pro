  Set_plot,'z'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;To call the smooth function: smooth(MeanFillingFactorAtGap(0,*),10,/edge_truncate)
  plot,time,MeanFillingFactorAtGap(0,*),background=255,$                            
       color=0,yrange=[3.0d-3,9.9],$
       psym=5,xstyle=1,ystyle=1,xtitle='time (years)',charsize=1.5,$
       xtickinterval=300000,thick=2,/ylog,$;,XMARGIN=[10,10],YMARGIN=[10,10];ytickinterval=10
ytitle='<  filling factor at gap >'
         f=strtrim(f,2)
  numberPlanets=strtrim(nPlanets,2)
  xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
  xyouts,150,520,numberPlanets+' planets',charsize=1.5,charthick=1,color=0,/device
x_axis=dblarr(1)
if f eq 1 then x_axis[0]=185000.
if f eq 10 then x_axis[0]=250000.
if f eq 100 then x_axis[0]=540000.
triangle_symbol=dblarr(1)
triangle_symbol[0]=7.5
square_symbol=dblarr(1)
square_symbol[0]=5.3
cross_symbol=dblarr(1)
cross_symbol[0]=3.7

  oplot,time,MeanFillingFactorAtGap(0,*),color=70,symsize=1.2,psym=5,thick=2
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,390,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
  oplot,time,MeanFillingFactorAtGap(1,*),color=160,symsize=1.2,psym=6,thick=2
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
  oplot,time,MeanFillingFactorAtGap(2,*),color=250,symsize=1.2,psym=7,thick=2
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,390,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
  fillingFactorDodson=dblarr(outputs+1)
  fillingFactorDodson(*)=0.1
  oplot,time,fillingFactorDodson,color=0,linestyle=2,thick=2
;DAY=FINDGEN(12) * 30 + 15
;  axis,xaxis=1,xticks=10,xtickv=day,xtitle='time',xcharsize=1,/save
;  axis,yaxis=1,ystyle=1,ytitle='Mass planet',/save
;  oplot,day,MeanFillingFactorAtGap(0,*)*10.,color=250,psym=4

  write_png,strcompress(dischargeImagesFolder+'/Time_FillingFactorGap.png',$
                        /remove_all),tvrd(0,0,600,600,0,true=1)
