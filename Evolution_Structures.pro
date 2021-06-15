Pro Evolution_Structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Programa que presenta la evolución de las estructuras
;de gas del disco protoplanetario.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  f=100                           ;Accretion parameter
  nPlanets_=4                    ;Number of planets
;  outputs_=300                   ;The outputs

  for nPlanets=2,nPlanets_ do begin
;Read the correct out
  if f eq 1 and nPlanets eq 2 then out=8
  if f eq 1 and nPlanets eq 3 then out=10
;  if f eq 1 and nPlanets eq 4 then out=11
  if f eq 1 and nPlanets eq 4 then out=18
  if f eq 10 and nPlanets eq 2 then out=14
  if f eq 10 and nPlanets eq 3 then out=12
  if f eq 10 and nPlanets eq 4 then out=13
  if f eq 100 and nPlanets eq 2 then out=9
;  if f eq 100 and nPlanets eq 3 then out=16
  if f eq 100 and nPlanets eq 3 then out=19
;  if f eq 100 and nPlanets eq 4 then out=17
  if f eq 100 and nPlanets eq 4 then out=20

;to find the outputs number by out
outAsString = STRTRIM(out, 2)
  spawn,'ls -l ~/ram_vogto/fargo/out'+outAsString+'/gasdens*.dat | wc -l',outputs
  for j=1,1001 do begin
     a=STRTRIM(j, 2)
     if (a eq outputs) then outputs=j-1 ;Final output per out
  endfor
if f eq 1 then outputs=350
if f eq 10 then outputs=450
if f eq 100 then outputs=1000
print,f,nPlanets,outputs
 
  
  dischargeImagesFolder='~/Dropbox/visualization_tools/images/StructuresEvolution/f'+string(f)+'_p'+string(nPlanets)
  dataFolder='~/ram_vogto/fargo/out'+string(out)
  dims=dblarr(8)
  dims_=strcompress(dataFolder+'/dims.dat',/remove_all)
  openr,1,dims_
  readf,1,dims
  close,1
  nsec = uint(dims(7))
  nrad = uint(dims(6))

;goto,jumpfinal
;Optical depth ranges:
  TauRanges=3
  
;Maximun number of structures per tau range:
  Struct_max=40 
  
;Used arrays:
  rad=dblarr(nrad+1)                           ;Radial array
  A=dblarr(nsec,nrad)                          ;Area Cell array
  ATau=dblarr(TauRanges,outputs+1)             ;Area per Tau array
  Counter=dblarr(nrad,Tauranges)      ;Count the cells radially per tau range
  dens=dblarr(nsec,nrad)                       ;Density array 
  vrad=dblarr(nsec,nrad)                       ;Radial velocity array
  accretion=dblarr(nsec,nrad)
  vtheta=dblarr(nsec,nrad)                     ;Theta velocity array
  MassTau=dblarr(TauRanges,outputs+1)          ;Mass per tau range
  Structure_Number=dblarr(TauRanges,outputs+1) ;Structure number per output per tau range
  time=1000*findgen(outputs+1)                 ;Time
  RadioDeCavidad=dblarr(outputs+1)
  Structures_Inner=dblarr(TauRanges,outputs+1) ;Internal structures
  Structures_Extern=dblarr(TauRanges,outputs+1) ;External structures
  MeanFillingFactorAtGap=dblarr(TauRanges,outputs+1)
  MassInsideHill=dblarr(nPlanets,outputs+1)
  AccPlanet=dblarr(nPlanets,outputs+1)
  MassPlanet=dblarr(nPlanets,outputs+1)
  ATauHill=dblarr(nPlanets,TauRanges,outputs+1)
  MassTauHill=dblarr(nPlanets,TauRanges,outputs+1)
  MeanFillingFactorAtHill=dblarr(nPlanets,TauRanges,outputs+1)
  VrPlanetCellHill=dblarr(nPlanets,outputs+1)
  rPlanetCellHill=dblarr(nPlanets,outputs+1)
  AccMeanHill=dblarr(nPlanets,outputs+1)
  AccMeanHillMinus=dblarr(nPlanets,outputs+1)
  CounterInsideHill=dblarr(nPlanets,outputs+1,5)
  SigmaSlopeHill=dblarr(nPlanets,outputs+1)
  SigmaInnerHill=dblarr(nPlanets,outputs+1)
  MeanDensityAtGap=dblarr(TauRanges,outputs+1)
  Structure_NumberMassive=dblarr(TauRanges,outputs+1)
  densAtPlanet=dblarr(nPlanets,outputs+1)

;Put the radius on array form:
  rad_=strcompress(dataFolder+'/used_rad.dat',/remove_all)
  openr,1,rad_
  readf,1,rad
  close,1
  rmin=rad(0)
  rmax=rad(nrad)
  
;Put the area space on arrray form
  for i=0,nrad do begin
     if (i gt 0) then begin
        for j=0,nsec-1 do begin
           A[j,i-1]=2*!PI*(rad[i]^2-rad[i-1]^2)/nsec
        endfor
     endif
  endfor
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Inicia barrido de salidas de datos:
;init_time=330
;counter_temp_time=1
  for n=0,outputs,10 do begin
;    if n eq init_time then begin
;      counter+=1
;    endif     
;Used arrays:
     DensTau=dblarr(nsec,nrad,TauRanges)          ;Density array per tau range
     i_=dblarr(TauRanges)                         ;i index for initial structure
     j_=dblarr(Tauranges)         ;j index for initial structure
     Block_prev=dblarr(TauRanges)                 ;Array for count structures
     Block=dblarr(nsec,nrad,TauRanges,Struct_max) ;Structure array per tau range
     BlockRad_ini=dblarr(TauRanges,Struct_max)    ;
     BlockRad_fin=dblarr(TauRanges,Struct_max)
     BlockRad_Inner_ini=dblarr(TauRanges,Struct_max)
     BlockRad_Inner_fin=dblarr(TauRanges,Struct_max)
     BlockRad_Extern_ini=dblarr(TauRanges,Struct_max)
     BlockRad_Extern_fin=dblarr(TauRanges,Struct_max)
     
;Coloca la densidad en los arreglos:
     dens_=strcompress(dataFolder+'/gasdens'+string(n)+'.dat'$
                       ,/remove_all)
     openr,1,dens_
     readu,1,dens
     close,1
     
;Coloca la velocidad radial en los arreglos:
     vrad_=strcompress(dataFolder+'/gasvrad'+string(n)+'.dat'$
                       ,/remove_all)
     openr,1,vrad_
     readu,1,vrad
     close,1
     
;Coloca la velocidad azimutal en los arreglos:
     vtheta_=strcompress(dataFolder+'/gasvtheta'+string(n)+$
                         '.dat',/remove_all)
     openr,1,vtheta_
     readu,1,vtheta
     close,1   
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;    Analisis of Optical depth:
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;            
;Searching the minimum of i index from DensTau[j,i.l] and finding the currents:
     for i=0,nrad-1 do begin
        for j=0,nsec-1 do begin
           tau=9.6*dens[j,i]*2./2.25*1.e7 ;Optical depth Troilita,etc.
           
;Optically thin:
           if (tau lt 0.5) then begin
              l=0
              Counter[i,l] += 1
              DensTau[j,i,l]=dens[j,i]
;              MassTau[l,n] += dens[j,i]*A[j,i]
;              ATau[l,n] += A[j,i]
           endif
           
;Optically transitional:
           if (tau ge 0.5) and (tau le 2.0) then begin
              l=1
              Counter[i,l] += 1
              DensTau[j,i,l]=dens[j,i]
;              MassTau[l,n] += dens[j,i]*A[j,i]
;              ATau[l,n] += A[j,i]
           endif
           
;Optically thick:
           if (tau gt 2.0) then begin
              l=2
              Counter[i,l] += 1
              DensTau[j,i,l]=dens[j,i]
;              MassTau[l,n] += dens[j,i]*A[j,i]
;              ATau[l,n] += A[j,i]
           endif
        endfor
     endfor
;Begin the currents:     
     for l=0,TauRanges-1 do begin
        tot=total(DensTau[*,*,l])
        if tot eq 0 then begin
           m=0
           Block_prev[l]=m
           goto,jump0
        endif else begin
           m=1
        endelse
        jump6:
        
;The first cell of the structure is found
        for i=0,nrad-1 do begin
           for j=0,nsec-1 do begin
              if DensTau[j,i,l] gt 0 then begin
                 j_[l]=j
                 i_[l]=i
                 Block[j,i,l,m]=m
                 Block_prev[l]=Block[j,i,l,m]
                 goto,jump1
              endif
           endfor
        endfor
        jump1:
;     print,'l    =',l,'           m      =',uint(m)        
;The structure is found in the first ring
        for i=0,nrad-1 do begin
           if (i eq i_[l]) then begin
              for j=0,nsec-1 do begin
                 if (j gt j_[l]) and (j le nsec-1) then begin
                    if (DensTau[j,i,l] gt 0) and (j lt nsec-1) then begin
                       Block[j,i,l,m]=Block_prev[l]
                       Block_prev[l]=Block[j,i,l,m]
                    endif
                    if (DensTau[j,i,l] gt 0) and (j eq nsec-1) then begin
                       Block[j,i,l,m]=Block[j-1,i,l,m]
                       Block_prev[l]=Block[j,i,l,m]
                    endif
                    if (DensTau[j,i,l] eq 0) then goto,jump2
                 endif
              endfor     
              jump2:
              for j=nsec-1,0,-1 do begin
                 if j eq nsec-1 then begin
                    if (Denstau[j,i,l] gt 0) $
                       and (Block[0,i,l,m] eq Block_prev[l]) then begin
                       Block[j,i,l,m]=Block_prev[l]
                       Block_prev[l]=Block[j,i,l,m]
                    endif
                 endif
                 if (j lt nsec-1) and (j gt 0) then begin
                    if (Denstau[j,i,l] gt 0) $
                       and (Block[j+1,i,l,m] eq Block_prev[l]) then begin
                       Block[j,i,l,m]=Block[j+1,i,l,m]
                       Block_prev[l]=Block[j,i,l,m]
                       if (Denstau[j,i,l] eq 0) then goto,jump3
                    endif
                 endif
              endfor
           endif
        endfor
        jump3:
        
;We try to find the structure squeleton 
        m=Block_prev[l]
        for i=0,nrad-1 do begin
           if (i gt i_[l]) then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (DensTau[j,i,l] gt 0) and $
                       ((Block[nsec-1,i-1,l,m] gt 0) $
                        or (Block[j,i-1,l,m] gt 0) $
                        or (Block[j+1,i-1,l,m] gt 0)) then begin
                       Block[j,i,l,m]=m
                       Block_prev[l]=Block[j,i,l,m]
                    endif                    
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (DensTau[j,i,l] gt 0) and $
                       ((Block[j-1,i-1,l,m] gt 0) $
                        or (Block[j,i-1,l,m] gt 0) $
                        or (Block[j+1,i-1,l,m] gt 0)) then begin                
                       Block[j,i,l,m]=m
                       Block_prev[l]=Block[j,i,l,m]
                    endif
                 endif
                 if (j eq nsec-1) then begin
                    if (DensTau[j,i,l] gt 0) and $
                       ((Block[j-1,i-1,l,m] gt 0) $
                        or (Block[j,i-1,l,m] gt 0) $
                        or (Block[0,i-1,l,m] gt 0)) then begin
                       Block[j,i,l,m]=m
                       Block_prev[l]=Block[j,i,l,m]
                    endif                    
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                    if (DensTau[j,i,l] gt 0) and $
                       ((Block[j-1,i-1,l,m] gt 0) $
                        or (Block[j,i-1,l,m] gt 0) $
                        or (Block[0,i-1,l,m] gt 0)) then begin
                       Block[j,i,l,m]=m
                       Block_prev[l]=Block[j,i,l,m]
                    endif                    
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (DensTau[j,i,l] gt 0) and $
                       ((Block[j-1,i-1,l,m] gt 0) $
                        or (Block[j,i-1,l,m] gt 0) $
                        or (Block[j+1,i-1,l,m] gt 0)) then begin                
                       Block[j,i,l,m]=m
                       Block_prev[l]=Block[j,i,l,m]
                    endif
                 endif
                 if (j eq 0) then begin
                    if (DensTau[j,i,l] gt 0) and $
                       ((Block[nsec-1,i-1,l,m] gt 0) $
                        or (Block[j,i-1,l,m] gt 0) $
                        or (Block[j+1,i-1,l,m] gt 0)) then begin
                       Block[j,i,l,m]=m
                       Block_prev[l]=Block[j,i,l,m]
                    endif                    
                 endif
              endfor
           endif
        endfor
        for i=nrad-2,0,-1 do begin
           for j=0,nsec-1 do begin
              if (j eq 0) then begin
                 if (DensTau[j,i,l] gt 0) and $
                    ((Block[nsec-1,i+1,l,m] gt 0) $
                     or (Block[j,i+1,l,m] gt 0) $
                     or (Block[j+1,i+1,l,m] gt 0)) then begin
                    Block[j,i,l,m]=m
                    Block_prev[l]=Block[j,i,l,m]
                 endif                    
              endif
              if (j gt 0) and (j lt nsec-1) then begin
                 if (DensTau[j,i,l] gt 0) and $
                    ((Block[j-1,i+1,l,m] gt 0) $
                     or (Block[j,i+1,l,m] gt 0) $
                     or (Block[j+1,i+1,l,m] gt 0)) then begin                
                    Block[j,i,l,m]=m
                    Block_prev[l]=Block[j,i,l,m]
                 endif
              endif
              if (j eq nsec-1) then begin
                 if (DensTau[j,i,l] gt 0) and $
                    ((Block[j-1,i+1,l,m] gt 0) $
                     or (Block[j,i+1,l,m] gt 0) $
                     or (Block[0,i+1,l,m] gt 0)) then begin
                    Block[j,i,l,m]=m
                    Block_prev[l]=Block[j,i,l,m]
                 endif                    
              endif
           endfor
           for j=nsec-1,0,-1 do begin
              if (j eq nsec-1) then begin
                 if (DensTau[j,i,l] gt 0) and $
                    ((Block[j-1,i+1,l,m] gt 0) $
                     or (Block[j,i+1,l,m] gt 0) $
                     or (Block[0,i+1,l,m] gt 0)) then begin
                    Block[j,i,l,m]=m
                    Block_prev[l]=Block[j,i,l,m]
                 endif                    
              endif
              if (j gt 0) and (j lt nsec-1) then begin
                 if (DensTau[j,i,l] gt 0) and $
                    ((Block[j-1,i+1,l,m] gt 0) $
                     or (Block[j,i+1,l,m] gt 0) $
                     or (Block[j+1,i+1,l,m] gt 0)) then begin                
                    Block[j,i,l,m]=m
                    Block_prev[l]=Block[j,i,l,m]
                 endif
              endif
              if (j eq 0) then begin
                 if (DensTau[j,i,l] gt 0) and $
                    ((Block[nsec-1,i+1,l,m] gt 0) $
                     or (Block[j,i+1,l,m] gt 0) $
                     or (Block[j+1,i+1,l,m] gt 0)) then begin
                    Block[j,i,l,m]=m
                    Block_prev[l]=Block[j,i,l,m]
                 endif                    
              endif
           endfor
        endfor
        
;To determine the lack of material of each structure
        for i=0,nrad-1 do begin 
           for j=0,nsec-1 do begin
              if (DensTau[j,i,l] gt 0) and $
                 (Block[j,i,l,m] ne Block_prev[l]) $
              then Block[j,i,l,m]=999
           endfor
        endfor

        jump4:
;The path of 0 to nrad-1 
        for i=0,nrad-1 do begin
           if i eq 0 then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]                    
                 endif
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l] 
                 endif
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
           endif
           if i gt 0 and i lt nrad-1 then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
           endif
           if i eq nrad-1 then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
           endif
        endfor

;The path of nrad-1 to 0
        for i=nrad-1,0,-1 do begin
           if i eq nrad-1 then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                   if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
           endif
           if i gt 0 and i lt nrad-1 then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[0,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[j-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m) $
                            or (Block[nsec-1,i-1,l,m] eq m) $
                            or (Block[j,i-1,l,m] eq m) $
                            or (Block[j+1,i-1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
           endif
           if i eq 0 then begin
              for j=0,nsec-1 do begin
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
              for j=nsec-1,0,-1 do begin
                 if (j eq nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[0,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[0,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[j-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[j-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
                 if (j eq 0) then begin
                    if (Block[j,i,l,m] eq 999) $
                       and ((Block[nsec-1,i,l,m] eq m) $
                            or (Block[j+1,i,l,m] eq m) $
                            or (Block[nsec-1,i+1,l,m] eq m) $
                            or (Block[j,i+1,l,m] eq m) $
                            or (Block[j+1,i+1,l,m] eq m)) $
                    then Block[j,i,l,m]=Block_prev[l]
                 endif
              endfor
           endif
        endfor
        
;Here begin the search of the missing cells
        for i=0,nrad-1 do begin
           if i eq 0 then begin
              for j=0,nsec-1 do begin 
                 if j eq 0 then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[nsec-1,i,l,m] eq m) $
                             or (Block[j+1,i,l,m] eq m) $
                             or (Block[nsec-1,i+1,l,m] eq m) $
                             or (Block[j,i+1,l,m] eq m) $
                             or (Block[j+1,i+1,l,m] eq m)) $
                     then goto,jump4                      
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[j-1,i,l,m] eq m) $
                             or (Block[j+1,i,l,m] eq m) $
                             or (Block[j-1,i+1,l,m] eq m) $
                             or (Block[j,i+1,l,m] eq m) $
                             or (Block[j+1,i+1,l,m] eq m)) $
                     then goto,jump4
                 endif
                 if j eq nsec-1 then begin
                    if (Block[j,i,l,m] eq 999) $
                        and ((Block[j-1,i,l,m] eq m) $
                             or (Block[0,i,l,m] eq m) $
                             or (Block[j-1,i+1,l,m] eq m) $
                             or (Block[j,i+1,l,m] eq m) $
                             or (Block[0,i+1,l,m] eq m)) $
                     then goto,jump4                     
                 endif
              endfor
           endif
           if (i gt 0) and (i lt nrad-1) then begin
              for j=0,nsec-1 do begin 
                 if j eq 0 then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[nsec-1,i,l,m] eq m) $
                             or (Block[j+1,i,l,m] eq m) $
                             or (Block[nsec-1,i+1,l,m] eq m) $
                             or (Block[j,i+1,l,m] eq m) $
                             or (Block[j+1,i+1,l,m] eq m) $
                             or (Block[j+1,i-1,l,m] eq m) $
                             or (Block[j,i-1,l,m] eq m) $
                             or (Block[nsec-1,i-1,l,m] eq m)) $
                     then goto,jump4                    
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[j-1,i,l,m] eq m) $
                             or (Block[j+1,i,l,m] eq m) $
                             or (Block[j-1,i+1,l,m] eq m) $
                             or (Block[j,i+1,l,m] eq m) $
                             or (Block[j+1,i+1,l,m] eq m) $
                             or (Block[j+1,i-1,l,m] eq m) $
                             or (Block[j,i-1,l,m] eq m) $
                             or (Block[j-1,i-1,l,m] eq m)) $
                     then goto,jump4
                 endif
                 if j eq nsec-1 then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[j-1,i,l,m] eq m) $
                             or (Block[0,i,l,m] eq m) $
                             or (Block[j-1,i+1,l,m] eq m) $
                             or (Block[j,i+1,l,m] eq m) $
                             or (Block[0,i+1,l,m] eq m) $
                             or (Block[0,i-1,l,m] eq m) $
                             or (Block[j,i-1,l,m] eq m) $
                             or (Block[j-1,i-1,l,m] eq m)) $
                     then goto,jump4                    
                 endif
              endfor
           endif
           if j eq nrad-1 then begin
              for j=0,nsec-1 do begin 
                 if (j eq 0) then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[nsec-1,i,l,m] eq m) $
                             or (Block[j+1,i,l,m] eq m) $
                             or (Block[j+1,i-1,l,m] eq m) $
                             or (Block[j,i-1,l,m] eq m) $
                             or (Block[nsec-1,i-1,l,m] eq m)) $
                     then goto,jump4                    
                 endif
                 if (j gt 0) and (j lt nsec-1) then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[j-1,i,l,m] eq m) $
                             or (Block[j+1,i,l,m] eq m) $
                             or (Block[j+1,i-1,l,m] eq m) $
                             or (Block[j,i-1,l,m] eq m) $
                             or (Block[j-1,i-1,l,m] eq m)) $
                     then goto,jump4
                 endif
                 if (j eq nsec-1) then begin
                     if (Block[j,i,l,m] eq 999) $
                        and ((Block[j-1,i,l,m] eq m) $
                             or (Block[0,i,l,m] eq m) $
                             or (Block[0,i-1,l,m] eq m) $
                             or (Block[j,i-1,l,m] eq m) $
                             or (Block[j-1,i-1,l,m] eq m)) $
                     then goto,jump4                    
                 endif
              endfor
           endif
        endfor
        jump0:
        Block_prov1=Block
        m_prev=Block_prev[l]
        
;Aqui termina la busqueda de los elementos de la estructura
        for i=0,nrad-1 do begin
           for j=0,nsec-1 do begin
              if (Block[j,i,l,m] eq 999) $
              then Block[j,i,l,m]=0
           endfor
        endfor
        Block_prov2=Block
        
;Para determinar existencia de otra estructura
        for i=0,nrad-1 do begin
           for j=0,nsec-1 do begin
              if (Block_prov1[j,i,l,m] eq 999) then begin 
                 Block_prev[l]+=1
                 goto,jump5
              endif
           endfor
        endfor
        jump5:
        
;Hace un salto hacia la estructura, en caso de haberse encontrado
        m=Block_prev[l]
        if (m gt m_prev) then begin
           for i=0,nrad-1 do begin
              for j=0,nsec-1 do begin
                 if Block_prov2[j,i,l,m_prev] gt 0 $
                 then DensTau[j,i,l]=0
              endfor
           endfor
           goto,jump6
        endif
        Structure_Number[l,n]=m
     endfor
     
;Escribe las estructuras en archivos y manipula datos en estructuras:
     for l=0,TauRanges-1 do begin
        counter1=0
        counter2=0
        for m=1,Block_prev[l] do begin
           r_i=0
           r_o=0
           for i=0,nrad-1 do begin
              for j=0,nsec-1 do begin
                 if (Block[j,i,l,m] eq m) then begin
                    BlockRad_ini[l,m]=rad[i]
                    r_i=rad[i]
                    goto,jump7          
                 endif
              endfor
           endfor
           jump7:
           ;; for i=nrad-1,0,-1 do begin
           ;;    for j=nsec-1,0,-1 do begin
           ;;       if (Block[j,i,l,m] eq m) then begin
           ;;          BlockRad_fin[l,m]=rad[i]
           ;;          r_o=rad[i]
           ;;          goto,jump8          
           ;;       endif 
           ;;    endfor
           ;; endfor
           if BlockRad_ini[l,m] eq rad[nrad-1] then begin
              BlockRad_fin[l,m]=rmax
              goto,jump8
           endif
           for i=0,nrad-1 do begin
              if (rad[i] gt BlockRad_ini[l,m]) $
                 and (BlockRad_ini[l,m] lt rad[nrad-1]) then begin
                 contador=0
                 for j=0,nsec-1 do begin
                    if (Block[j,i,l,m] eq m) then begin
                       contador += 1
                    endif
                 endfor
                 if (contador eq 0) $
                    and (r_i eq rad[i-1]) then begin
                    BlockRad_fin[l,m]=rad[i]
                    goto,jump8
                 endif
                 if (contador eq 0) then begin
                    BlockRad_fin[l,m]=rad[i+1]
                    goto,jump8
                 endif
              endif
           endfor
           jump8:
           if (BlockRad_fin[l,m] gt rmin) $
              and (BlockRad_ini[l,m] ge rmin) $
              and (BlockRad_fin[l,m] lt 1.0) then begin
              BlockRad_Inner_fin[l,m]=BlockRad_fin[l,m]
              BlockRad_Inner_ini[l,m]=BlockRad_ini[l,m]
              counter1+=1
              Structures_Inner[l,n]=counter1
           endif
           if (BlockRad_ini[l,m] gt 180.0) $
              and (BlockRad_fin[l,m] gt 180.0) $
              and (BlockRad_fin[l,m] le rmax) then begin
              BlockRad_Extern_fin[l,m]=BlockRad_fin[l,m]
              BlockRad_Extern_ini[l,m]=BlockRad_ini[l,m]
              counter2+=1
              Structures_Extern[l,n]=counter2
           endif
           if (l eq 1) then begin
              if (BlockRad_fin[l,m] gt 1.0) $
                 and (BlockRad_fin[l,m] lt 100.0) then begin
                 if m eq 1 then begin
                    RadioDeCavidad[n]=BlockRad_fin[l,m]
                 endif
                 if (m gt 1) then begin
                    if (BlockRad_fin[l,m] gt RadioDeCavidad[n]) then begin
                       RadioDeCavidad[n]=BlockRad_fin[l,m]
                    endif
                 endif
              endif
           endif
        endfor
     endfor
     MassPerBlock=dblarr(3,40)
     DustMassPerBlock=dblarr(3,40)
     counterMassive=dblarr(3)
     for l=0,TauRanges-1 do begin
        for m=1,Block_prev[l] do begin
           for i=0,nrad-1 do begin
              for j=0,nsec-1 do begin
                 if Block[j,i,l,m] gt 0 then begin
                    MassPerBlock[l,m]+=dens[j,i]*A[j,i]
                 endif
              endfor
           endfor
           DustMassPerBlock[l,m]=MassPerBlock(l,m)*0.005168
           if DustMassPerBlock[l,m]/0.001*317. ge 0.0055772788 then begin; m=0.0055772788 earth mass which correspond to a maximum SED considering the emission of silicate dust with relation 1:100 with relation to the gas 
              counterMassive[l]+=1
           endif
        endfor
        Structure_NumberMassive(l,n)=counterMassive[l]
     endfor     
;     Imprime numero de estructuras en el tiempo    
     print,time(n),Structure_Number(*,n),Structure_NumberMassive(*,n);,RadioDeCavidad(n)
     
; The calculus of mean filling factor at determined time
; The filling factor is calculated for perturbed gas between the inner and the extern planet;
     mplanet=dblarr(nPlanets)
     xPlanet=dblarr(nPlanets)
     yPlanet=dblarr(nPlanets)
     vxPlanet=dblarr(nPlanets)
     vyPlanet=dblarr(nPlanets)
     Rplanet=dblarr(nPlanets)
     Hillplanet=dblarr(nPlanets)
     ThetaPlanet=dblarr(nPlanets)
     alpha=dblarr(nsec)
     xHill=dblarr(nPlanets,nsec)
     yHill=dblarr(nPlanets,nsec)
     HillplanetTheta=dblarr(nPlanets,nsec)
     HillplanetR=dblarr(nPlanets,nsec)
     Semieje=dblarr(nPlanets)
     NearUpperRadPlanet=dblarr(nPlanets)
     aa=dblarr(nPlanets)

     rmed = (rad(1:nrad)-rad(0:nrad-1))/2+rad(0:nrad-1)
     vradbig = [vrad[*,*],vrad[0,*]]
     vthetabig = [vtheta[*,*],vtheta[0,*]]
     vrCentered=interpolate(vradbig,dindgen(nsec),dindgen(nrad)+0.5,/grid)
     vpCentered=interpolate(vthetabig,dindgen(nsec)+0.5,dindgen(nrad),/grid)
     rmedt = rmed##replicate(1,nsec)
     accretion = (2.*!PI/nsec)*dens*rmedt*VrCentered

     for i=0,nPlanets-1 do begin
        planetAsString = STRTRIM(i, 2)
        outAsString = STRTRIM(out, 2)
        planet_=strcompress('~/ram_vogto/fargo/out'+outAsString+'/planet'+planetAsString+'.dat',/remove_all)
        openr,1,planet_
        s=dblarr(9)
        planet=dblarr(9,n+1)
        oldS=0
        WHILE ~ EOF(1) DO BEGIN
           readf,1,s 
           if ((s[0] eq oldS) and (s[0] ne 0)) then continue 
           nn=abs(s[0])
           planet[*,nn]=s
           oldS=s[0]
           if (s[0] eq n) then goto,jumpy
        ENDWHILE
        jumpy:
        xPlanet[i]=planet[1,n]
        yPlanet[i]=planet[2,n]
        vxPlanet[i]=planet[3,n]
        vyPlanet[i]=planet[4,n]  
        mplanet[i]=planet[5,n]
        close,1

        h=xPlanet[i]*vyPlanet[i]-yPlanet[i]*vxPlanet[i]
        d=sqrt(xPlanet[i]*xPlanet[i]+yPlanet[i]*yPlanet[i])
        Ax=xPlanet[i]*vyPlanet[i]*vyPlanet[i]-yPlanet[i]*vxPlanet[i]*vyPlanet[i]-xPlanet[i]/d
        Ay=yPlanet[i]*vxPlanet[i]*vxPlanet[i]-xPlanet[i]*vxPlanet[i]*vyPlanet[i]-yPlanet[i]/d
        e=sqrt(Ax*Ax+Ay*Ay)
        aa[i]=h*h/(1.-e*e)
;     SemiejeMax=max(SemiMajorAxis)
;     SemiejeMin=min(SemiMajorAxis)



        
        Rplanet[i]=sqrt(xplanet[i]^2+yplanet[i]^2)
        ThetaPlanet[i]=atan(yplanet[i],xplanet[i])+(1.0/nsec*2*!PI)
        if (ThetaPlanet[i] < 0.) then ThetaPlanet[i]=2.*!PI+ThetaPlanet[i]+(1.0/nsec*2*!PI)
	xplanet[i]=Rplanet[i]*cos(ThetaPlanet[i])
	yplanet[i]=Rplanet[i]*sin(ThetaPlanet[i])
        Hillplanet[i]=aa[i]*(1.-e)*((1./3)*mplanet[i])^(1./3.);aa(1.-e)
        for j=0,nsec-1 do begin
           Alpha[j]=((j+0.5)/nsec)*2*!PI
           if (j eq 0) then  alpha[j]=0.001
           if (j eq nsec-1) then  alpha[j]=2*!PI
           xHill[i,j]=Rplanet[i]*cos(ThetaPlanet[i])+Hillplanet[i]*cos(alpha[j])
           yHill[i,j]=Rplanet[i]*sin(ThetaPlanet[i])+Hillplanet[i]*sin(alpha[j])
           HillplanetTheta[i,j]=atan(yHill[i,j],xHill[i,j])
           if (HillplanetTheta[i,j] < 0.) then HillplanetTheta[i,j]=$
              2.*!PI+HillplanetTheta[i,j]
           HillplanetR[i,j]=sqrt(yHill[i,j]^2+xHill[i,j]^2)
        endfor
        x=dblarr(nsec,nrad)
        y=dblarr(nsec,nrad)
        for ii=0,nrad-1 do begin
           for jj=0,nsec-1 do begin
	      CounterCellsHill_0=0.
	      CounterCellsHill_1=0.
	      CounterCellsHill_2=0.
              x[jj,ii]=rmed[ii]*cos(alpha[jj])
              y[jj,ii]=rmed[ii]*sin(alpha[jj])  
	      Rp_Rmed=sqrt((x[jj,ii]-xplanet[i])^2+(y[jj,ii]-yplanet[i])^2)    
	      if Rp_Rmed lt Hillplanet[i]*0.7 then begin
                tau=9.6*dens[jj,ii]*2./2.25*1.e7 ;Optical depth Troilita,etc.  
;Optically thin:
             	 if (tau lt 0.5) then begin
                    l=0
		    CounterCellsHill_0+=1
		    CounterInsideHill[i,n,l]+=CounterCellsHill_0
                    MassTauHill[i,l,n] += dens[jj,ii]*A[jj,ii]
                    ATauHill[i,l,n] += A[jj,ii]
;		    if i eq 0 then print,l,Rp_Rmed,Hillplanet[i],ATauHill[i,l,n],A[jj,ii],!PI*Hillplanet[0]*Hillplanet[0],jj,ii
	         endif 	

;Optically intermediate:
             	 if (tau ge 0.5) and (tau le 2.0) then begin
                    l=1
		    CounterCellsHill_1+=1
		    CounterInsideHill[i,n,l]+=CounterCellsHill_1
                    MassTauHill[i,l,n] += dens[jj,ii]*A[jj,ii]
                    ATauHill[i,l,n] += A[jj,ii]
;		    if i eq 0 then print,l,Rp_Rmed,Hillplanet[i],ATauHill[i,l,n],A[jj,ii],!PI*Hillplanet[0]*Hillplanet[0],jj,ii
	         endif 	
;Optically thick:
             	 if (tau gt 2.0) then begin
                    l=2
		    CounterCellsHill_2+=1
		    CounterInsideHill[i,n,l]+=CounterCellsHill_2
                    MassTauHill[i,l,n] += dens[jj,ii]*A[jj,ii]
                    ATauHill[i,l,n] += A[jj,ii]
;		    if i eq 0 then print,l,Rp_Rmed,Hillplanet[i],ATauHill[i,l,n],A[jj,ii],!PI*Hillplanet[0]*Hillplanet[0],jj,ii
	         endif 		
	      endif        
           endfor
        endfor
;---------------------------------------------------------------------
        MassPlanet[i,n]=mplanet[i] ;The mass accretion calculation
	if n ge 20 then AccPlanet[i,n]=(MassPlanet[i,n]-MassPlanet[i,n-10])/10000.        
;---------------------------------------------------------------------
;        CounterHill=0
;	CounterAccHill=0
;        Counter0Hill=0
;        Counter1Hill=0
;        Counter2Hill=0
;        Counter3Hill=0
;        Counter4Hill=0
;        densHill0=0
;        densHill1=0
;        densHill2=0
;        densHill3=0
;        densHill4=0
;	AccMeanHill(i,n)=0
;	AccMeanHillMinus(i,n)=0
;	xProv=xPlanet[i]
;	yProv=yPlanet[i]
;	print,xPlanet[i],yPlanet[i]

;	distPlanetCell=dblarr(nsec,nrad)
;        for ii=0,nrad-1 do begin
;           for j=0,nsec-1 do begin
;              xdiff=x[j,ii]-xPlanet[i]
;              ydiff=y[j,ii]-yPlanet[i] 
;              distPlanetCell[j,ii]=sqrt((xdiff*xdiff)+(ydiff*ydiff))
;           endfor
;        endfor
;
;	dens_max=0
;        for ii=0,nrad-1 do begin
;           for j=0,nsec-1 do begin
;              if (distPlanetCell[j,ii] le Hillplanet[i]) and (n ge 0) then begin
;		if dens_max lt dens[j,ii] then begin
;		  dens_max=dens[j,ii]	
;		  xPlanet[i]=rmed[ii]*cos(alpha[j])
;		  yPlanet[i]=rmed[ii]*sin(alpha[j]) 
;		  densAtPlanet[i,n]=dens_max
;		endif
;	      endif
;           endfor
;        endfor
;        for ii=0,nrad-1 do begin
;           for j=0,nsec-1 do begin
;              xdiff=x[j,ii]-xPlanet[i]
;              ydiff=y[j,ii]-yPlanet[i]
;              distPlanetCell[j,ii]=sqrt((xdiff*xdiff)+(ydiff*ydiff))
;              if distPlanetCell[j,ii] le 0.2*Hillplanet[i] then Counter0Hill+=1 
;              if (distPlanetCell[j,ii] gt 0.2*Hillplanet[i]) and (distPlanetCell[j,ii] le 0.4*Hillplanet[i]) then Counter1Hill+=1
;              if (distPlanetCell[j,ii] gt 0.4*Hillplanet[i]) and (distPlanetCell[j,ii] le 0.6*Hillplanet[i]) then Counter2Hill+=1
;              if (distPlanetCell[j,ii] gt 0.6*Hillplanet[i]) and (distPlanetCell[j,ii] le 0.8*Hillplanet[i]) then Counter3Hill+=1
;              if (distPlanetCell[j,ii] gt 0.8*Hillplanet[i]) and (distPlanetCell[j,ii] le Hillplanet[i]) then Counter4Hill+=1
;           endfor
;        endfor
;        print,CounterInsideHill(i,n,*)
;        for ii=0,nrad-1 do begin
;           for j=0,nsec-1 do begin
;              xdiff=x[j,ii]-xPlanet[i]
;              ydiff=y[j,ii]-yPlanet[i] 
;              distPlanetCell=sqrt((xdiff*xdiff)+(ydiff*ydiff))
;              if distPlanetCell le Hillplanet[i] then begin
;                 CounterHill+=1;
;		 
;                 MassInsideHill[i,n]+=dens[j,ii]*A[j,ii]
;                 vxdiff=(vrCentered[j,ii]*cos(Alpha[j]))-(vpCentered[j,ii]*sin(Alpha[j]))-vxPlanet[i]
;                 vydiff=(vrCentered[j,ii]*sin(Alpha[j]))+(vpCentered[j,ii]*cos(Alpha[j]))-vyPlanet[i]
;                 VrPlanetCellHill[i,n]=sqrt((vxdiff*vxdiff)+(vydiff*vydiff));
;		 thetaR=atan(ydiff,xdiff);
;		 thetaVr=atan(vydiff,vxdiff)
;		 thetaR_Vr=thetaR-thetaVr
;		 if thetaR_Vr lt 0. then thetaR_Vr=2*!PI+thetaR_Vr
;                 if distPlanetCell le 0.2*Hillplanet[i] then begin 
;                    AccMeanHill[i,n]=2.*!PI/CounterInsideHill[i,n,0]*dens[j,ii]*distPlanetCell*VrPlanetCellHill[i,n]*cos(thetaR_Vr)
;                    densHill0+=dens[j,ii]
;                 endif
;                 if (distPlanetCell gt 0.2*Hillplanet[i]) and (distPlanetCell le 0.4*Hillplanet[i]) then begin 
;                    AccMeanHill[i,n]=2.*!PI/CounterInsideHill[i,n,1]*dens[j,ii]*distPlanetCell*VrPlanetCellHill[i,n]*cos(thetaR_Vr)
;                    densHill1+=dens[j,ii]
;                 endif
;                 if (distPlanetCell gt 0.4*Hillplanet[i]) and (distPlanetCell le 0.6*Hillplanet[i]) then begin 
;                    AccMeanHill[i,n]=2.*!PI/CounterInsideHill[i,n,2]*dens[j,ii]*distPlanetCell*VrPlanetCellHill[i,n]*cos(thetaR_Vr)
;                    densHill2+=dens[j,ii]
;                 endif
;                 if (distPlanetCell gt 0.6*Hillplanet[i]) and (distPlanetCell le 0.8*Hillplanet[i]) then begin 
;                    AccMeanHill[i,n]=2.*!PI/CounterInsideHill[i,n,3]*dens[j,ii]*distPlanetCell*VrPlanetCellHill[i,n]*cos(thetaR_Vr)
;                    densHill3+=dens[j,ii]
;                 endif
;                 if (distPlanetCell gt 0.8*Hillplanet[i]) and (distPlanetCell le Hillplanet[i]) then begin 
;                    AccMeanHill[i,n]=2.*!PI/CounterInsideHill[i,n,4]*dens[j,ii]*distPlanetCell*VrPlanetCellHill[i,n]*cos(thetaR_Vr)
;                    densHill4+=dens[j,ii]
;                 endif
                 

                 
;                 AccMeanHill[i,n]=2.*!PI/nsec*dens[j,ii]*distPlanetCell*VrPlanetCellHill[i,n]*cos(thetaR_Vr)
;		 print,AccMeanHill[i,n],thetaR_Vr,distPlanetCell,ii,j,Hillplanet[i]
;                 if AccMeanHill[i,n] lt 0 then begin
;                    CounterAccHill+=1		   
;                    AccMeanHillMinus[i,n]+=AccMeanHill[i,n]
;                 endif



                 
                 
                 
;                 print,x[j,ii],y[j,ii],xPlanet[i],yPlanet[i]-
;For quantify the mass by optical depth into the Hill Radii
;                 tau=9.6*dens[j,ii]*2./2.25*1.e7 ;Optical depth Troilita,etc.              
;Optically thin:
;                 if (tau lt 0.5) then begin
;                    l=0
;                    MassTauHill[i,l,n] += dens[j,ii]*A[j,ii] 
;                    ATauHill[i,l,n] += A[j,ii]
;                 endif
;Optically intermediate:
;                 if (tau ge 0.5) and (tau le 2.0) then begin
;                    l=1
;                    MassTauHill[i,l,n] += dens[j,ii]*A[j,ii]
;                    ATauHill[i,l,n] += A[j,ii]
;                 endif
;Optically thick:
;                 if (tau gt 2.0) then begin
;                    l=2
;                    MassTauHill[i,l,n] += dens[j,ii]*A[j,ii]
;                    ATauHill[i,l,n] += A[j,ii]
;                 endif
;              endif
;           endfor
;        endfor
;        print,densHill0/CounterInsideHill[i,n,0],densHill1/CounterInsideHill[i,n,1],densHill2/CounterInsideHill[i,n,2],densHill3/CounterInsideHill[i,n,3],densHill4/CounterInsideHill[i,n,4]
;        print,alog10((densHill0/CounterInsideHill[i,n,0])/(densHill1/CounterInsideHill[i,n,1]))/alog10((0.1*HillPlanet[i])/(0.3*HillPlanet[i]))
;	print,alog10(total(dens(*,200))/total(dens(*,201)))/alog10(rad(200)/rad(201))
;        SigmaSlopeHill(i,n)=alog10((densHill1/CounterInsideHill[i,n,1])/(densHill0/CounterInsideHill[i,n,0]))/alog10((0.3*HillPlanet[i])/(0.1*HillPlanet[i]))        
;        SigmaInnerHill(i,n)=densHill0/CounterInsideHill[i,n,0]
        MeanFillingFactorAtHill(i,0,n)=AtauHill(i,0,n)/total(ATauHill(i,*,n))
        MeanFillingFactorAtHill(i,1,n)=AtauHill(i,1,n)/total(ATauHill(i,*,n))
        MeanFillingFactorAtHill(i,2,n)=AtauHill(i,2,n)/total(ATauHill(i,*,n))
;        AccMeanHillMinus(i,n)=abs(AccMeanHillMinus(i,n))/CounterHill
;	if (n lt 20) then AccMeanHillMinus(i,n)=0
;	if (n lt 20) then AccPlanet(i,n)=0
;        print,CounterHill,AccMeanHillMinus(i,n)/0.001,AccPlanet(i,n)/0.001
;        VrPlanetCellHill(i,n)/CounterHill(0)
;        print,vyPlanet(i),VrPlanetCellHill(i,n)/CounterHill
;        print,i,CounterHill
;        print,MeanFillingFactorAtHill(i,*,n)
;        print,MassInsideHill(i,n)
;        print,MassTauHill(i,*,n)
;     print,AtauHill(0,n)/total(ATauHill(*,n)),AtauHill(1,n)/total(ATauHill(*,n)),AtauHill(2,n)/total(ATauHill(*,n))
;---------------------------------------------------------------------        
     endfor     
;     h=xPlanet*vyPlanet-yPlanet*vxPlanet
;     d=sqrt(xPlanet*xPlanet+yPlanet*yPlanet)
;     Ax=xPlanet*vyPlanet*vyPlanet-yPlanet*vxPlanet*vyPlanet-xPlanet/d
;     Ay=yPlanet*vxPlanet*vxPlanet-xPlanet*vxPlanet*vyPlanet-yPlanet/d
;     e=sqrt(Ax*Ax+Ay*Ay)
;     SemiMajorAxis=h*h/(1-e*e)
;     SemiejeMax=max(SemiMajorAxis)
;     SemiejeMin=min(SemiMajorAxis)
     
;  for i=0,nrad-1 do begin
;     if counter[i,2]/nsec lt 1 then begin
;        Rad_fno1_ini=rad[i]
;        break
;     endif
;  endfor
;  for i=nrad-1,0,-1 do begin
;     if counter[i,2]/nsec lt 1 then begin
;        Rad_fno1_fin=rad[i]
;        break
;     endif
;  endfor
;     catch,theError
;     if theError ne 0 then goto,jumpf
;  print,Rad_fno1_ini,Rad_fno1_fin     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; TmpCounter=0
     ;; FillingFactorAtGap=0
     ;; for i=0,nrad do begin
     ;;    if ((rad[i] ge (Rplanet[0]-(2*HillPlanet[0]))) and (rad[i] le (Rplanet[nPlanets-1]-(2*HillPlanet[nPlanets-1])))) then begin
     ;;       TmpCounter+=1
     ;;       FillingFactorAtGap+=Counter[i,0]/nsec
     ;;    endif
     ;; endfor
     ;; MeanFillingFactorAtGap[0,n]=FillingFactorAtGap/TmpCounter
     ;; print,MeanFillingFactorAtGap[0,n]
     ;; TmpCounter=0
     ;; FillingFactorAtGap=0
     ;; for i=0,nrad do begin
     ;;    if ((rad[i] ge (Rplanet[0]-(2*HillPlanet[0]))) and (rad[i] le (Rplanet[nPlanets-1]-(2*HillPlanet[nPlanets-1])))) then begin
     ;;       TmpCounter+=1
     ;;       FillingFactorAtGap+=Counter[i,1]/nsec
     ;;    endif
     ;; endfor
     ;; MeanFillingFactorAtGap[1,n]=FillingFactorAtGap/TmpCounter
     ;; print,MeanFillingFactorAtGap[1,n]
     ;; TmpCounter=0
     ;; FillingFactorAtGap=0
     ;; for i=0,nrad do begin
     ;;    if ((rad[i] ge (Rplanet[0]-(2*HillPlanet[0]))) and (rad[i] le (Rplanet[nPlanets-1]-(2*HillPlanet[nPlanets-1])))) then begin
     ;;       TmpCounter+=1
     ;;       FillingFactorAtGap+=Counter[i,2]/nsec
     ;;    endif
     ;; endfor
     ;; MeanFillingFactorAtGap[2,n]=FillingFactorAtGap/TmpCounter
     ;; print,MeanFillingFactorAtGap[2,n]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;jumpf:

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
     counter(*,*)=0
     for i=0,nrad-1 do begin
;        if ((rad[i] ge (Rplanet[0]-(2*HillPlanet[0]))) and (rad[i] le (Rplanet[nPlanets-1]-(2*HillPlanet[nPlanets-1])))) then begin
        if ((rad[i] ge gapBorder[0]) and (rad[i] le gapBorder[1])) then begin
           for j=0,nsec-1 do begin
              tau=9.6*dens[j,i]*2./2.25*1.e7 ;Optical depth Troilita,etc.              
;Optically thin:
              if (tau lt 0.5) then begin
                 l=0
                 MassTau[l,n] += dens[j,i]*A[j,i]
                 ATau[l,n] += A[j,i]
              endif
;Optically intermediate:
              if (tau ge 0.5) and (tau le 2.0) then begin
                 l=1
                 MassTau[l,n] += dens[j,i]*A[j,i]
                 ATau[l,n] += A[j,i]
              endif
;Optically thick:
              if (tau gt 2.0) then begin
                 l=2
                 MassTau[l,n] += dens[j,i]*A[j,i]
                 ATau[l,n] += A[j,i]
              endif
           endfor
        endif
     endfor
;For quantify the filling factor at gap
     MeanFillingFactorAtGap(0,n)=Atau(0,n)/total(ATau(*,n))
     MeanFillingFactorAtGap(1,n)=Atau(1,n)/total(ATau(*,n))
     MeanFillingFactorAtGap(2,n)=Atau(2,n)/total(ATau(*,n))
     MeanDensityAtGap(0,n)=MassTau(0,n)/total(Atau(*,n))
     MeanDensityAtGap(1,n)=MassTau(1,n)/total(Atau(*,n))
     MeanDensityAtGap(2,n)=MassTau(2,n)/total(Atau(*,n))
;     print,total(Atau(*,n))
     print,MeanDensityAtGap(0,n)*0.005168*2./2.25*1.e7,MeanDensityAtGap(1,n)*0.005168*2./2.25*1.e7,MeanDensityAtGap(2,n)*0.005168*2./2.25*1.e7
  endfor   
  
;Graphics:
  device,get_decompose=old_decomposed,decomposed=0
  loadct,3
@Evolution_StructuresNumber.pro
@Evolution_StructuresNumberMassive.pro
@Evolution_StructuresMass.pro
;@Evolution_StructuresATau.pro
;@Evolution_StructuresInner.pro
;@Evolution_StructuresExtern.pro
@Evolution_StructuresFillingFactor.pro
@Evolution_StructuresFillingFactorInsideHill.pro
@Evolution_StructuresMassInsideHill.pro
@Evolution_StructuresAcretion.pro
@Evolution_StructuresSigmaSlopeHill.pro
@Evolution_StructuresSigmaInnerHill.pro
@Evolution_StructuresSigmaAtPlanet.pro
@Evolution_StructuresMeanDensityAtGap.pro
;jumpfinal:
endfor
  RETURN
end
