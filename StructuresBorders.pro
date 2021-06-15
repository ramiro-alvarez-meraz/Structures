; Make a vector of 16 points, A[i] = 2pi/16:
A = FINDGEN(17) * (!PI*2/16.)
; Define the symbol to be a unit circle with 16 points, 
; and set the filled flag:
USERSYM, COS(A), SIN(A), /FILL

  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
;  window,10,xsize=600,ysize=600
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
   for l=0,TauRanges-1 do begin
     for m=1,Block_prev[l] do begin
        Structures[l,m]=m
     endfor
  endfor 
  SemiejeMaxArray=dblarr(Struct_max)
  SemiejeMinArray=dblarr(Struct_max)
;Ciclos para calculo de densidad media
  densMed=dblarr(nrad)
  tot=dblarr(nrad)
  gapBorder=dblarr(2)
  for r=0,nrad-1 do begin
     tot[r]=0.0
     for l=0,nsec-1 do begin
        tot[r]=dens[l,r]+tot[r]
     endfor
  endfor
  for r=0,nrad-1 do begin
     densMed[r]=tot[r]/nsec
  endfor
  densCGSmed = densMed*2./2.25*1.e7
  tauMed=9.6*densCGSmed
  for r=nrad-1,0,-1 do begin
     if rad[r] lt Rplanet[0] then begin
        if tauMed[r] ge 2. then begin
           gapBorder[0]=rad[r]
           break
        endif
     endif
  endfor
  for r=0,nrad-1 do begin
     if rad[r] gt Rplanet[nPlanets-1] then begin
        if tauMed[r] ge 2. then begin
           gapBorder[1]=rad[r]
           break
        endif
     endif
  endfor
print,gapBorder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  SemiejeMaxArray(*)=SemiejeMax+(2*HillPlanet[nPlanets-1])
;  SemiejeMinArray(*)=SemiejeMin-(2*HillPlanet[0])
  SemiejeMaxArray(*)=gapBorder[1]
  SemiejeMinArray(*)=gapBorder[0]
  Struct_maxArray=findgen(Struct_max)
  plot,Structures(0,*)+0.5,BlockRad_ini(0,*),background=255,$                            
       color=0,ytitle='inner and outer edge of the structure ( AU )',yrange=[0.1,210],xrange=[1,15],psym=5,symsize=1.,thick=3,xstyle=1,$
       xtitle='Structure #',charsize=1.5,/ylog,ystyle=1,XTICKINTERVAL=1,XTICKLAYOUT=2
  f=strtrim(f,2)
  nPlanets=strtrim(nPlanets,2)
  xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
  xyouts,150,520,nPlanets+' planets',charsize=1.5,charthick=1,color=0,/device
  xyouts,140,500,strcompress(string(ulong(output*1000.))+' years'),charsize=1.5,charthick=1,color=0,/device
  if out eq 52 then xyouts,150,480,'indirect term',charsize=1.5,charthick=1,color=0,/device
  oplot,Structures(0,*)+0.5,BlockRad_fin(0,*),color=70,psym=5,symsize=1.,thick=3
  for l=0,TauRanges-1 do begin
     if l eq 0 then begin
        simb=5
        col=70
     endif
     if l eq 1 then begin 
        simb=6
        col=160
     endif
     if l eq 2 then begin
        simb=7
        col=250
     endif
    oplot,Structures(l,*)+0.5,BlockRad_ini(l,*),color=col,psym=simb,symsize=1.,thick=3  
    oplot,Structures(l,*)+0.5,BlockRad_fin(l,*),color=col,psym=simb,symsize=1.,thick=3 
  if l eq 1 then begin 
    ;Puting a new color table
    device,get_decompose=old_decomposed,decomposed=0
    loadct,9   
    oplot,Structures(l,*)+0.5,BlockRad_ini(l,*),color=col,psym=simb,symsize=1.,thick=3 
    oplot,Structures(l,*)+0.5,BlockRad_fin(l,*),color=col,psym=simb,symsize=1.,thick=3
    ;Returning to the old color table
    device,get_decompose=old_decomposed,decomposed=0
    loadct,39
  endif 
  endfor
  oplot,Struct_maxArray(*)+0.5,SemiejeMinArray(*),color=0,psym=0
  oplot,Struct_maxArray(*)+0.5,SemiejeMaxArray(*),color=0,psym=0
  print,SemiejeMaxArray(0)
x_axis=dblarr(1)
x_axis[0]=9.;5.7
triangle_symbol=dblarr(1)
triangle_symbol[0]=160.
square_symbol=dblarr(1)
square_symbol[0]=115.
cross_symbol=dblarr(1)
cross_symbol[0]=82.
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
  xyouts,400,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
  xyouts,400,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
  xyouts,400,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device


  SemiejeArray=findgen(Struct_max,nPlanets)
  for i=0,nPlanets-1 do begin
    SemiejeArray(*,i)=Semieje(i)
    oplot,Struct_maxArray(*),SemiejeArray(*,i),color=0,psym=0,linestyle=2
  endfor
  write_png,strcompress(dischargeImagesFolder+$
                        '/Structures-Sizes.png',/remove_all),tvrd(0,0,600,600,0,true=1)
