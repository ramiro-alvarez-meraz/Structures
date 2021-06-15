Pro CompareResolution

  f=1                           ;Accretion parameter
  nPlanets=2                    ;Number of planets


  dischargeImagesFolder='~/Dropbox/visualization_tools/images/CompareResolution'
  dtDump=1000.
  if f eq 1 then begin
    outputs=320
    finalTime=outputs*dtDump
    xinterval=150000
  endif

  time=findgen(outputs+1)*dtDump
print,finalTime
  device,get_decompose=old_decomposed,decomposed=0
  loadct,3


@NormalResolution.pro ;Causing Arithmetic error
a_InnerPlanet_NormalResolution=SemiMajorAxis(*,0)
a_InnerPlanet_NormalResolution[0]=12.5
print,a_InnerPlanet_NormalResolution
a_OuterPlanet_NormalResolution=SemiMajorAxis(*,1)
a_OuterPlanet_NormalResolution[0]=20.
  oplot,time,MeanSemiMajorAxisNormalResolution,color=0,linestyle=2
  write_png,strcompress(dischargeImagesFolder+$
                        '/NormalResolution.png',/remove_all),tvrd(0,0,600,600,0,true=1)


@HighResolution.pro  ;Causing Arithmetic error
a_InnerPlanet_HighResolution=SemiMajorAxis(*,0)
a_InnerPlanet_HighResolution[0]=12.5
a_OuterPlanet_HighResolution=SemiMajorAxis(*,1)
a_OuterPlanet_HighResolution[0]=20.
  oplot,time,MeanSemiMajorAxisHighresolution,color=0,linestyle=2
  write_png,strcompress(dischargeImagesFolder+$
                        '/HighResolution.png',/remove_all),tvrd(0,0,600,600,0,true=1)


@HigherResolution.pro  ;Causing Arithmetic error
a_InnerPlanet_HigherResolution=SemiMajorAxis(*,0)
a_InnerPlanet_HigherResolution[0]=12.5
a_OuterPlanet_HigherResolution=SemiMajorAxis(*,1)
a_OuterPlanet_HigherResolution[0]=20.
  oplot,time,MeanSemiMajorAxisHigherResolution,color=0,linestyle=2
  write_png,strcompress(dischargeImagesFolder+$
                        '/HigherResolution.png',/remove_all),tvrd(0,0,600,600,0,true=1)

        Set_plot,'z'
        Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,MeanSemiMajorAxisNormalResolution,background=255,$                            
             color=0,xtitle='time (yrs)',yrange=[10,20],xrange=[0,finalTime],psym=0,xstyle=1,$
             ytitle='Mean semi-major axis (AU)',charsize=2.0,xtickinterval=xinterval
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
        oplot,time,MeanSemiMajorAxisHigherResolution,color=70,linestyle=2
        xyouts,300,520,'(448,384)',charsize=1.5,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
        oplot,time,MeanSemiMajorAxisHighResolution,color=160,linestyle=2
        xyouts,300,500,'(384,384)',charsize=1.5,color=160,/device
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
        xyouts,300,480,'(384,256)',charsize=1.5,color=250,/device
        oplot,time,MeanSemiMajorAxisNormalResolution,color=250,linestyle=2

  write_png,strcompress(dischargeImagesFolder+$
                        '/CompareResolution.png',/remove_all),tvrd(0,0,600,600,0,true=1)


        Set_plot,'z'
        Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,time,a_InnerPlanet_HigherResolution,background=255,$                            
             color=0,xtitle='time (yrs)',yrange=[0,25],xrange=[0,finalTime],psym=0,xstyle=1,$
             ytitle='a (AU)',charsize=2.0,xtickinterval=xinterval
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
        oplot,time,a_InnerPlanet_HigherResolution,color=70,linestyle=2
        oplot,time,a_OuterPlanet_HigherResolution,color=70,linestyle=2
;        xyouts,300,520,'(448,384)',charsize=1.5,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
        oplot,time,a_InnerPlanet_HighResolution,color=160,linestyle=2
        oplot,time,a_OuterPlanet_HighResolution,color=160,linestyle=2
;        xyouts,300,500,'(384,384)',charsize=1.5,color=160,/device
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
;        xyouts,300,480,'(384,256)',charsize=1.5,color=250,/device
        oplot,time,a_InnerPlanet_NormalResolution,color=250,linestyle=2
        oplot,time,a_OuterPlanet_NormalResolution,color=250,linestyle=2
  write_png,strcompress(dischargeImagesFolder+$
                        '/CompareResolution_SemimajorAxis.png',/remove_all),tvrd(0,0,600,600,0,true=1)

 RETURN
end
