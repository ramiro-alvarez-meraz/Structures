Pro StellarAcc

  f=1 ;Accretion parameter

;Read uts with the equal accretion parameter
  if f eq 1 then begin 
     outs=3
     out=dblarr(outs)
     out[0]=8
     out[1]=10
     out[2]=11
  endif
  if f eq 10 then begin
     outs=3
     out=dblarr(outs)
     out[0]=14
     out[1]=12
     out[2]=13
  endif
  if f eq 100 then begin
     outs=3
     out=dblarr(outs)
     out[0]=9
     out[1]=16
     out[2]=17
  endif
  for i=0,outs-1 do begin
     new_out=out[i]
     new_out=uint(new_out)
     numberAsString = STRTRIM(new_out, 2)
     spawn,'ls -l ~/ram_vogto/fargo/out'+numberAsString+'/gasdens*.dat | wc -l',outputs
     for j=1,1001 do begin
        a=STRTRIM(j, 2)
        if (a eq outputs) then outputs=j-1 ;Final output per out
     endfor
;     outputs=300 ;outputs at determined time
print,outputs
     planet_=strcompress('~/ram_vogto/fargo/out'+string(new_out)+'/planet0.dat',/remove_all)
     openr,1,planet_
     s=dblarr(9)
     planet=dblarr(9,outputs+1)
     oldS=0
     WHILE ~ EOF(1) DO BEGIN
        readf,1,s 
        if ((s[0] eq oldS) and (s[0] ne 0)) then continue 
        nn=abs(s[0])
        planet[*,nn]=s
        oldS=s[0]
     ENDWHILE
     close,1
     StellarAcc=dblarr(outputs+1)
     for k=1,outputs do begin
        StellarAcc[k]=(planet[6,k]-planet[6,k-1])/1000       
     endfor
     if i eq 0 then begin
        time=findgen(1001)*1000
        device,get_decompose=old_decomposed,decomposed=0
        loadct,3
;        window,0,xsize=600,ysize=600
     Set_plot,'z'
     Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,smooth(StellarAcc,10,/edge_truncate),background=255,$                            
             color=0,xtitle='time (years)',yrange=[1.e-12,1.e-7],xrange=[0,300000],psym=0,xstyle=1,/ylog,$
             ytitle='dM/dt  (M!L!9n!3!N/year)',charsize=2.0,xtickinterval=150000,thick=2
line_x=dblarr(2)
line_x[0]=160000.
line_x[1]=180000.
solid_line=dblarr(2)
solid_line[0]=6.e-8
solid_line[1]=6.e-8
        xyouts,420,530,'2 planets',charsize=1.5,charthick=2,color=0,/device
        oplot,line_x,solid_line,color=0,linestyle=0,thick=2
        f=STRTRIM(f, 2)
        xyouts,200,520,'f='+f,charsize=1.5,charthick=2,color=0,/device
     endif
     if i eq 1 then begin
        dash=dblarr(2)
        dash[0]=3.2e-8
        dash[1]=3.2e-8
        oplot,time,smooth(StellarAcc,10,/edge_truncate),color=0,linestyle=2,thick=2
        xyouts,420,505,'3 planets',charsize=1.5,charthick=2,color=0,/device
        oplot,line_x,dash,color=0,linestyle=2,thick=2       
     endif
     if i eq 2 then begin
        dash_dot=dblarr(2)
        dash_dot[0]=1.8e-8
        dash_dot[1]=1.8e-8
        oplot,time,smooth(StellarAcc,10,/edge_truncate),color=0,linestyle=3,thick=2
        oplot,line_x,dash_dot,color=0,linestyle=3,thick=2
        xyouts,420,480,'4 planets',charsize=1.5,charthick=2,color=0,/device
     endif
  endfor
  write_png,strcompress('~/Dropbox/visualization_tools/images/StellarAcc/StellarAcc_f'+string(f)+'.png',/remove_all),tvrd(0,0,600,600,0,true=1)

RETURN
end
