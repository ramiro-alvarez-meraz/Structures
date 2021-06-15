;  window,0,xsize=600,ysize=600
Set_plot,'z'
device,get_decompose=old_decomposed,decomposed=0
loadct,39
Device,Set_resolution=[600,600],Set_Pixel_Depth=24
;; !P.MULTI = [0,2,2,0,0]
;; n = 17.0
;; theta = findgen(n)/(n-1.0)*360.0*!DtoR
;; x = 1.0*sin(theta)
;; y = 1.0*cos(theta)
;; usersym, x, y
;; plot,time,Structure_NumberMassive(0,*),ytitle='# Structures',$
;;      background=255,color=0,ytickinterval=1,yrange=[0.5,3],$
;;      psym=1,xstyle=1,ystyle=1,charsize=1,xtickinterval=300000
;; oplot,time,Structure_NumberMassive(0,*),psym=1,color=70
;; f=strtrim(f,2)
;; numberPlanets=strtrim(nPlanets,2)
;; plot,time,Structure_NumberMassive(1,*),ytitle='# Structures',$
;;      color=0,psym=1,xtickinterval=300000,ytickinterval=1,yrange=[0.5,3],$
;;      xstyle=1,ystyle=1,charsize=1
;; oplot,time,Structure_NumberMassive(1,*),psym=1,color=160
;; plot,time,Structure_NumberMassive(2,*),ytitle='# Structures',$
;;      color=0,psym=1,xtickinterval=300000,ytickinterval=1,yrange=[0.5,3],$
;;      xtitle='time (years)',charsize=1,xstyle=1,ystyle=1
;; oplot,time,Structure_NumberMassive(2,*),psym=1,color=250
;; xyouts,400,210,'f='+f,charsize=2,color=0,/device
;; xyouts,400,150,numberPlanets+' planets',charsize=2,color=0,/device
;; xyouts,100,550,'    !4s!X < 0.5',charsize=1.5,color=70,/device
;; xyouts,400,550,'0.5 < !4s!X < 2.0',charsize=1.5,color=160,/device
;; xyouts,100,250,'    !4s!X > 2',charsize=1.5,color=250,/device
 !P.MULTI = [0,1,1,0,0]
 plot,time,Structure_NumberMassive(0,*),ytitle='# Structures',$
      background=255,color=0,yrange=[0.5,3.],$
      xtitle='time (years)',charsize=1.5,psym=5,xstyle=1,ystyle=1,$
      xtickinterval=300000,thick=3,YTICKINTERVAL=1
 f=strtrim(f,2)
 numberPlanets=strtrim(nPlanets,2)
 xyouts,150,540,'f='+f,charsize=1.5,charthick=1,color=0,/device
 xyouts,150,520,numberPlanets+' planets',charsize=1.5,charthick=1,color=0,/device
x_axis=dblarr(1)
x_axis[0]=180000.
triangle_symbol=dblarr(1)
triangle_symbol[0]=2.9
square_symbol=dblarr(1)
square_symbol[0]=2.8
cross_symbol=dblarr(1)
cross_symbol[0]=2.7
 oplot,time,Structure_NumberMassive(0,*),psym=5,symsize=1.2,thick=3,color=70
oplot,x_axis,triangle_symbol,psym=5,symsize=1.5,thick=3,color=70
 xyouts,390,540,'!4s!X < 0.5',charsize=1.5,charthick=2,color=70,/device
;Puting a new color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,9
 oplot,time,Structure_NumberMassive(1,*),psym=6,symsize=1.2,thick=3,color=160
oplot,x_axis,square_symbol,psym=6,symsize=1.5,thick=3,color=160
 xyouts,390,520,'0.5 < !4s!X < 2.0',charsize=1.5,charthick=2,color=160,/device
;Returning to the old color table
  device,get_decompose=old_decomposed,decomposed=0
  loadct,39
 oplot,time,Structure_NumberMassive(2,*),psym=7,symsize=1.5,thick=3,color=250
oplot,x_axis,cross_symbol,psym=7,symsize=1.5,thick=3,color=250
 xyouts,390,500,'!4s!X > 2.0',charsize=1.5,charthick=2,color=250,/device
write_png,strcompress(dischargeImagesFolder+'/Time_MassiveStructuresNumber.png',/remove_all),tvrd(0,0,600,600,0,true=1)

!P.MULTI = [0,1,1,0,0]
;;-----------------------------------------------------------------------------
