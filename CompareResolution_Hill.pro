Pro CompareResolution_Hill

  outputs=32
  Normal=dblarr(10,outputs)
  High=dblarr(10,outputs)
  Higher=dblarr(10,outputs)
  dataFolder='~/Dropbox/visualization_tools/images/CompareResolution'
  Normal_=strcompress(dataFolder+'/StructuresEvolution_NormalResolutionRatio_AtotalHill_to_RealHill.dat'$
                       ,/remove_all)
     openr,1,Normal_
     readf,1,Normal
     close,1

  dataFolder='~/Dropbox/visualization_tools/images/CompareResolution'
  High_=strcompress(dataFolder+'/StructuresEvolution_HighResolutionRatio_AtotalHill_to_RealHill.dat'$
                       ,/remove_all)
     openr,2,High_
     readf,2,High
     close,2

  dataFolder='~/Dropbox/visualization_tools/images/CompareResolution'
  Higher_=strcompress(dataFolder+'/StructuresEvolution_HigherResolutionRatio_AtotalHill_to_RealHill.dat'$
                       ,/remove_all)
     openr,3,Higher_
     readf,3,Higher
     close,3

;Non taking in account vallues at 10000 yrs
Normal(*,0)=0.
High(*,0)=0.
Higher(*,0)=0.
print,Normal

  xinterval=150000.
  device,get_decompose=old_decomposed,decomposed=0
  loadct,3
  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
 ;    Normal(1,*)=smooth(Normal(1,*),20,/edge_truncate,/NAN)
        plot,Normal(0,*),Normal(1,*),background=255,$                            
             color=0,xtitle='time (yrs)',yrange=[0.6,1.5],xrange=[0,Normal[0,outputs-1]],psym=0,xstyle=1,$
             ytitle='',charsize=2.0,xtickinterval=xinterval
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
;     Higher(1,*)=smooth(Higher(1,*),20,/edge_truncate,/NAN)
        oplot,Higher(0,*),Higher(1,*),color=70,linestyle=2
        xyouts,300,520,'(448,384)',charsize=1.5,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
;     High(1,*)=smooth(High(1,*),20,/edge_truncate,/NAN)
        oplot,High(0,*),High(1,*),color=160,linestyle=2
        xyouts,300,500,'(384,384)',charsize=1.5,color=160,/device
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
        xyouts,300,480,'(384,256)',charsize=1.5,color=250,/device
        oplot,Normal(0,*),Normal(1,*),color=250,linestyle=2

  write_png,strcompress(dataFolder+$
                        '/CompareResolution_Hill.png',/remove_all),tvrd(0,0,600,600,0,true=1)


  device,get_decompose=old_decomposed,decomposed=0
  loadct,3
  Set_plot,'z'
  Device,Set_resolution=[600,600],Set_Pixel_Depth=24
        plot,Normal(0,*),Normal(2,*),background=255,$                            
             color=0,xtitle='time (yrs)',yrange=[1.,1000],xrange=[0,Normal[0,outputs-1]],psym=0,xstyle=1,$
             ytitle='Area (AU!E2!N), # Cells (<0.7R!IH!N)',/ylog,charsize=2.0,xtickinterval=xinterval
  xyouts,200,510,'Inner planet',charsize=1.5,charthick=1,color=0,/device
  xyouts,300,300,'# Cells',charsize=1.5,charthick=1,color=0,/device
  xyouts,300,150,'Area',charsize=1.5,charthick=1,color=0,/device
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
        oplot,Higher(0,*),Higher(2,*),color=70,linestyle=2
        oplot,Higher(0,*),Higher(8,*),color=70,linestyle=2
        xyouts,410,520,'(448,384)',charsize=1.5,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
        oplot,High(0,*),High(2,*),color=160,linestyle=2
        oplot,High(0,*),High(8,*),color=160,linestyle=2
        xyouts,410,495,'(384,384)',charsize=1.5,color=160,/device
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
        xyouts,410,470,'(384,256)',charsize=1.5,color=250,/device
        oplot,Normal(0,*),Normal(2,*),color=250,linestyle=2
        oplot,Normal(0,*),Normal(8,*),color=250,linestyle=2

  write_png,strcompress(dataFolder+$
                        '/CompareResolution_InnerplanetNeighbourhood.png',/remove_all),tvrd(0,0,600,600,0,true=1)



  RETURN
end
