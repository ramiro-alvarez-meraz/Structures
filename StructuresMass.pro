     Set_plot,'z'
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
  MassPerBlock=dblarr(TauRanges,Struct_max)
  DustMassPerBlock=dblarr(TauRanges,Struct_max)
  for l=0,TauRanges-1 do begin
     for m=1,Block_prev[l] do begin
        MassPerBlock[l,m]=total(MassRadPerBlock(*,l,m))
        DustMassPerBlock[l,m]=total(MassRadPerBlock(*,l,m))*0.005168   
     endfor
  endfor
  plot,Structures(0,*)+0.5,DustMassPerBlock(0,*)/0.001*317.,background=255,$                            
       color=0,ytitle='Dust mass!L0.005-0.25 [!4l!Xm]!N ( M!L!20S!3!N )',yrange=[0.0000002,99],$;M!L!9n!3!N
       xrange=[1,11],psym=5,xstyle=1,XTICKINTERVAL=1,XTICKLAYOUT=2,$
       xtitle='Structure #',charsize=1.5,/ylog,ystyle=1
         f=strtrim(f,2)
  nPlanets=strtrim(nPlanets,2)
  xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
  xyouts,150,520,nPlanets+' planets',charsize=1.5,charthick=1,color=0,/device
  xyouts,140,500,strcompress(string(ulong(output*1000.))+' years'),charsize=1.5,charthick=1,color=0,/device
  if out eq 52 then xyouts,150,480,'indirect term',charsize=1.5,charthick=1,color=0,/device
  smallMass=dblarr(Struct_max)
  simpleArray=findgen(Struct_max)
;  smallMass(*)=0.0055772788
  smallMass(*)=0.001
  oplot,simpleArray(*),smallMass(*),color=0,psym=0,linestyle=1
  for l=0,TauRanges-1 do begin
     if l eq 0 then begin
        simb=5
        col=70
     endif
     if l eq 1 then begin 
        simb=6
;        simb=1
        col=160
     endif
     if l eq 2 then begin
        simb=7
;        simb=1
        col=250
     endif
     oplot,Structures(l,*)+0.5,DustMassPerBlock(l,*)/0.001*317.,color=col,psym=simb,thick=3
  if l eq 1 then begin 
    ;Puting a new color table
    device,get_decompose=old_decomposed,decomposed=0
    loadct,9   
     oplot,Structures(l,*)+0.5,DustMassPerBlock(l,*)/0.001*317.,color=col,psym=simb,thick=3
    ;Returning to the old color table
    device,get_decompose=old_decomposed,decomposed=0
    loadct,39
  endif 
  endfor
x_axis=dblarr(1)
x_axis[0]=5.7
triangle_symbol=dblarr(1)
triangle_symbol[0]=50.
square_symbol=dblarr(1)
square_symbol[0]=20.
cross_symbol=dblarr(1)
cross_symbol[0]=8.
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,350,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,350,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,350,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
  write_png,strcompress(dischargeImagesFolder+$
                        '/Structures-Mass.png',/remove_all),tvrd(0,0,600,600,0,true=1)
