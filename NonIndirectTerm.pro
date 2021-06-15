  SemiMajorAxis=dblarr(outputs+1,nPlanets)
  MeanSemiMajorAxisNonIndirectTerm=dblarr(outputs+1)

  for i=0,nPlanets-1 do begin
     planetAsString = STRTRIM(i, 2)
     planet_=strcompress('~/ram_vogto/fargo/out8/planet'+planetAsString+'.dat',/remove_all)
     openr,1,planet_
     s=dblarr(9)
     planet=dblarr(9,outputs+1)
     oldS=0
    for l=0,1100 do begin
        readf,1,s 
        if ((s[0] eq oldS) and (l gt 0)) then continue
        nn=abs(s[0])
        planet[*,nn]=s
        oldS=s[0]
        if (s[0] eq outputs) then break
    endfor
     close,1
     xPlanet=dblarr(outputs+1)
     yPlanet=dblarr(outputs+1)
     vxPlanet=dblarr(outputs+1)
     vyPlanet=dblarr(outputs+1)
     for k=1,outputs do begin
        xPlanet[k]=planet[1,k]
        yPlanet[k]=planet[2,k]
        vxPlanet[k]=planet[3,k]
	vyPlanet[k]=planet[4,k]
     endfor
     h=xPlanet*vyPlanet-yPlanet*vxPlanet
     d=sqrt(xPlanet*xPlanet+yPlanet*yPlanet)
     Ax=xPlanet*vyPlanet*vyPlanet-yPlanet*vxPlanet*vyPlanet-xPlanet/d
     Ay=yPlanet*vxPlanet*vxPlanet-xPlanet*vxPlanet*vyPlanet-yPlanet/d
     e=sqrt(Ax*Ax+Ay*Ay)
     a=h*h/(1-e*e)
;     a=smooth(a,10,/edge_truncate)
     if i eq 0 then begin
;        window,2,xsize=600,ysize=600
        Set_plot,'z'
        Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,a,background=255,$                            
             color=0,xtitle='time (yrs)',yrange=[0,25],xrange=[0,finalTime],psym=0,xstyle=1,$
             ytitle='AU',charsize=2.0,xtickinterval=xinterval
;        xyouts,430,520,'Planet 1',charsize=1.5,color=0,/device
        f=STRTRIM(f, 2)
        nPlanets=strtrim(nPlanets,2)
        xyouts,200,530,'f='+f,charsize=1.5,color=0,/device
        xyouts,200,510,nPlanets+' planets',charsize=1.5,color=0,/device
        for k=1,outputs do begin
           SemiMajorAxis[k,i]=a[k]
        endfor
     endif
     if i eq 1 then begin
        oplot,time,a,color=60
;        xyouts,430,490,'Planet 2',charsize=1.5,color=60,/device
        for k=1,outputs do begin
           SemiMajorAxis[k,i]=a[k]
        endfor
     endif
     if i eq 2 then begin
        oplot,time,a,color=120
        xyouts,430,460,'Planet 3',charsize=1.5,color=120,/device
        for k=1,outputs do begin
           SemiMajorAxis[k,i]=a[k]
        endfor
     endif
     if i eq 3 then begin
        oplot,time,a,color=180
        xyouts,430,430,'Planet 4',charsize=1.5,color=180,/device
        for k=1,outputs do begin
           SemiMajorAxis[k,i]=a[k]
        endfor
     endif

  endfor
  for k=0,outputs do begin
     MeanSemiMajorAxisNonIndirectTerm[k]=total(SemiMajorAxis(k,*))/nPlanets
  endfor
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constants for viscosity calculation
       AlphaVisc=.01
       CmByKm=100000.
       Cs=10.*CmByKm
       AU=1.5*10.^(13.)
       year=31556900.
       ViscUnits=(year)/(AU*AU)
;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if nPlanets eq 2 then begin
     MeanInitSemiMajorAxis=(20.+12.5)/2.
     print,'lalala'
     if f eq 1 then print,MeanSemiMajorAxisNonIndirectTerm[outputs]/MeanInitSemiMajorAxis
     if f eq 10 then print,MeanSemiMajorAxisNonIndirectTerm[outputs]/MeanInitSemiMajorAxis
     if f eq 100 then print,MeanSemiMajorAxisNonIndirectTerm[outputs]/MeanInitSemiMajorAxis
  endif
  if nPlanets eq 3 then begin
     MeanInitSemiMajorAxis=(20.+12.5+7.5)/3. 
     if f eq 1 then print,MeanSemiMajorAxisNonIndirectTerm[350]/MeanInitSemiMajorAxis
     if f eq 10 then print,MeanSemiMajorAxisNonIndirectTerm[450]/MeanInitSemiMajorAxis
     if f eq 100 then print,MeanSemiMajorAxisNonIndirectTerm[1000]/MeanInitSemiMajorAxis
  endif
  if nPlanets eq 4 then begin 

     MeanInitSemiMajorAxis=(20.+12.5+7.5+5.)/4.
     if f eq 1 then begin 
       print,MeanSemiMajorAxisNonIndirectTerm[200],MeanSemiMajorAxisNonIndirectTerm[350],MeanSemiMajorAxisNonIndirectTerm[350]/MeanInitSemiMajorAxis
       HeightScale=0.029*MeanInitSemiMajorAxis^(0.25)*(AU)
       Visc=0.01*Cs*HeightScale*ViscUnits
       ViscTime=(16.*MeanInitSemiMajorAxis^2)/(12.*Visc)
       print,MeanInitSemiMajorAxis,MeanInitSemiMajorAxis*AU,Visc,ViscTime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       HeightScale=0.029*MeanSemiMajorAxisNonIndirectTerm[350]^(0.25)*(AU)
       Visc=0.01*Cs*HeightScale*ViscUnits
       ViscTime=(16.*MeanSemiMajorAxisNonIndirectTerm[350]^2)/(12.*Visc)
       print,MeanSemiMajorAxisNonIndirectTerm[350]*AU,Visc,ViscTime
     endif
     if f eq 10 then print,MeanSemiMajorAxisNonIndirectTerm[450]/MeanInitSemiMajorAxis
     if f eq 100 then print,MeanSemiMajorAxisNonIndirectTerm[1000]/MeanInitSemiMajorAxis
  endif

