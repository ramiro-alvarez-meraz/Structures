  for i=0,nPlanets-1 do begin
     planetAsString = STRTRIM(i, 2)
    planet_=strcompress('~/ram_vogto/fargo/out'+outAsString+'/planet'+planetAsString+'.dat',/remove_all)
;    planet_=strcompress('~/ram_vogto/fargo/out'+string(out)+'/planet'+string(i)+'.dat',/remove_all)
;    planet_='/home/ramiro/ram_vogto/fargo/out18/planet0.dat'
     openr,1,planet_
     s=dblarr(9)
     planet=dblarr(9,outputs+1)
     oldS=0
;     WHILE ~ EOF(1) DO BEGIN
    for l=0,1100 do begin
        readf,1,s 
        if ((s[0] eq oldS) and (l gt 0)) then continue
        nn=abs(s[0])
        planet[*,nn]=s
        oldS=s[0]
        if (s[0] eq outputs) then break
    endfor
;     ENDWHILE
     close,1

     accPlanet=dblarr(outputs+1)
     for k=1,outputs do begin
        accPlanet[k]=(planet[5,k]-planet[5,k-1])/1000
     endfor

;Accretion rate of planets     
     if i eq 0 then begin       
;        window,0,xsize=600,ysize=600
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,smooth(accPlanet/0.001,10,/edge_truncate),background=255,$                            
             color=0,yrange=[1.e-7,1.e-4],xrange=[0,finalTime],psym=0,xstyle=1,/ylog,$
             xtitle='time (yrs)',ytitle='dM/dt  (Mj/year)',charsize=2.0,xtickinterval=xinterval
        xyouts,430,520,'Planet 1',charsize=1.5,color=0,/device
                f=STRTRIM(f, 2)
  nPlanets=strtrim(nPlanets,2)
        xyouts,200,520,'f='+f,charsize=1.5,color=0,/device
  xyouts,200,490,nPlanets+' planets system',charsize=1.5,color=0,/device
     endif
     if i eq 1 then begin
        oplot,time,smooth(accPlanet/0.001,10,/edge_truncate),color=60
        xyouts,430,490,'Planet 2',charsize=1.5,color=60,/device
     endif
     if i eq 2 then begin
        oplot,time,smooth(accPlanet/0.001,10,/edge_truncate),color=120
        xyouts,430,460,'Planet 3',charsize=1.5,color=120,/device
     endif
     if i eq 3 then begin
        oplot,time,smooth(accPlanet/0.001,10,/edge_truncate),color=180
        xyouts,430,430,'Planet 4',charsize=1.5,color=180,/device
     endif
  endfor
  
  write_png,strcompress(dischargeImagesFolder+$
                        '/PlanetAcc.png',/remove_all),tvrd(0,0,600,600,0,true=1)
