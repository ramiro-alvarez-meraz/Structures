Pro CompareIndirectTerm

  f=1                           ;Accretion parameter
  nPlanets=2                    ;Number of planets


  dischargeImagesFolder='~/Dropbox/visualization_tools/images/CompareIndirectTerm'
  dtDump=1000.
  if f eq 1 then begin
    outputs=350
    finalTime=outputs*dtDump
    xinterval=150000
  endif

  time=findgen(outputs+1)*dtDump
print,finalTime
  device,get_decompose=old_decomposed,decomposed=0
  loadct,3


@NonIndirectTerm.pro ;Causing Arithmetic error
;  oplot,time,MeanSemiMajorAxisNonIndirectTerm,color=0,linestyle=2
  write_png,strcompress(dischargeImagesFolder+$
                        '/NonIndirectTerm.png',/remove_all),tvrd(0,0,600,600,0,true=1)


@IndirectTerm.pro  ;Causing Arithmetic error
;  oplot,time,MeanSemiMajorAxisIndirectTerm,color=0,linestyle=2
  write_png,strcompress(dischargeImagesFolder+$
                        '/IndirectTerm.png',/remove_all),tvrd(0,0,600,600,0,true=1)

        Set_plot,'z'
        Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,MeanSemiMajorAxisNonIndirectTerm,background=255,$                            
             color=0,xtitle='time (yrs)',yrange=[0,25],xrange=[0,finalTime],psym=0,xstyle=1,$
             ytitle='Mean semi-major axis (AU)',charsize=2.0,xtickinterval=xinterval
        xyouts,300,400,'Including indirect term',charsize=1.5,color=0,/device
        xyouts,320,320,'Without indirect term',charsize=1.5,color=0,/device
        oplot,time,MeanSemiMajorAxisIndirectTerm,color=0,linestyle=2

  write_png,strcompress(dischargeImagesFolder+$
                        '/CompareIndirectTerm.png',/remove_all),tvrd(0,0,600,600,0,true=1)


 RETURN
end
