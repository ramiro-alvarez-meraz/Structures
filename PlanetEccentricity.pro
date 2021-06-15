  Eccentricity=dblarr(outputs+1,nPlanets)
  MeanEccentricity=dblarr(outputs+1)
  for i=0,nPlanets-1 do begin
     planetAsString = STRTRIM(i, 2)
     planet_=strcompress('~/ram_vogto/fargo/out'+outAsString+'/planet'+planetAsString+'.dat',/remove_all)
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
     e=smooth(e,20,/edge_truncate,/NAN)
     if i eq 0 then begin
;        window,3,xsize=600,ysize=600
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,e,background=255,$                            
             color=0,xtitle='time (years)',yrange=[0.001,1],xrange=[0,finalTime],psym=0,xstyle=1,$
             ytitle='e',/ylog,charsize=2.0,xtickinterval=xinterval
        xyouts,430,520,'Planet 1',charsize=1.5,color=0,/device
                f=STRTRIM(f, 2)
  nPlanetsStr=strtrim(i+2,2)
        xyouts,200,520,'f='+f,charsize=1.5,color=0,/device
  xyouts,200,490,nPlanetsStr+' planets system',charsize=1.5,color=0,/device
  for k=1,outputs do begin
     Eccentricity[k,i]=e[k]
  endfor
endif
     if i eq 1 then begin
        oplot,time,e,color=60
        xyouts,430,490,'Planet 2',charsize=1.5,color=60,/device
  for k=1,outputs do begin
     Eccentricity[k,i]=e[k]
  endfor
     endif
     if i eq 2 then begin
        oplot,time,e,color=120
        xyouts,430,260,'Planet 3',charsize=1.5,color=120,/device
  for k=1,outputs do begin
     Eccentricity[k,i]=e[k]
  endfor
     endif
    if i eq 3 then begin
        oplot,time,e,color=180
        xyouts,430,230,'Planet 4',charsize=1.5,color=180,/device
  for k=1,outputs do begin
     Eccentricity[k,i]=e[k]
  endfor
     endif
 endfor
  
  for k=0,outputs do begin
     MeanEccentricity[k]=total(Eccentricity(k,*))/nPlanets
  endfor
  oplot,time,MeanEccentricity,color=0,linestyle=2
  
  write_png,strcompress(dischargeImagesFolder+$
                        '/PlanetEccentricity.png',/remove_all),tvrd(0,0,600,600,0,true=1)
