PRO EX_BOX, X0, Y0, X1, Y1, color
   ; Call POLYFILL:
   POLYFILL, [X0, X0, X1, X1], [Y0, Y1, Y1, Y0], COL = color
END

PRO EX_BARGRAPH, minval
   ; Define variables:
;   @plot01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  f=1                           ;Accretion parameter
  nPlanets=4                   ;Number of planets
  output=350                    ;The output
StructuresPlanet=dblarr(nplanets,3)
  dischargeImagesFolder='~/Dropbox/visualization_tools/images/StructuresQuantification/f'+string(f)+'_p'+string(nPlanets)+'/output'+string(output)
;The input
StructuresPlanet_=strcompress(dischargeImagesFolder+'/StructuresByPlanet.dat',/remove_all)
openr,1,StructuresPlanet_
readf,1,StructuresPlanet
close,1

thin=StructuresPlanet(*,0)
intermediate=StructuresPlanet(*,1)
thick=StructuresPlanet(*,2)
ALLPTS = [[thin], [intermediate], [thick]]
PLANET = findgen(nplanets)+1
N1 = N_ELEMENTS(PLANET) - 1
NAMES=['thin','intermediate', 'thick']
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Width of bars in data units:
   del = 1./5.
   ; The number of colors used in the bar graph is
   ; defined by the number of colors available on your system:
   ncol=!D.N_COLORS/5

   ; Create a vector of color indices to be used in this procedure:
   colors = [70, 160, 250] ;ncol*INDGEN(4)+ncol
   ; Loop for each sample:
   FOR iscore = 0, 2 DO BEGIN
     if iscore eq 1 then begin
       device,get_decompose=old_decomposed,decomposed=0
       LOADCT,9
     endif else begin
       device,get_decompose=old_decomposed,decomposed=0
       LOADCT, 39
     endelse
   ; The y value of annotation. Vertical separation is 20 data
   ; units:
   yannot = minval + 1.5*(iscore+1)
   ; Label for each bar:
   XYOUTS, 5, yannot, names[iscore], color=0
   ; Bar for annotation:
   EX_BOX, 5, yannot - 0.1, 6, yannot - 0.7, colors[iscore]
   ; The x offset of vertical bar for each sample:
   xoff = iscore * del - 0.5 * del
   ; Draw vertical box for each year's sample:
   FOR iyr=0, N_ELEMENTS(planet)-1 DO $
      EX_BOX, planet[iyr] + xoff, minval, $
      planet[iyr] + xoff + del, $
      allpts[iyr, iscore], $
      colors[iscore] 

   ENDFOR
END



Pro StructuresByPlanetPlot
;@plot01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  f=1                           ;Accretion parameter
  nPlanets=4                   ;Number of planets
  output=350                    ;The output
StructuresPlanet=dblarr(nplanets,3)
;  dischargeImagesFolder='~/Dropbox/visualization_tools/images/StructuresQuantification/f'+string(f)+'_p'+string(nPlanets)+'/output'+string(output)
  dischargeImagesFolder='~/Dropbox/visualization_tools/images/StructuresQuantification/f'+string(f)+'_p'+string(nPlanets)+'/output'+string(output)
;The input
StructuresPlanet_=strcompress(dischargeImagesFolder+'/StructuresByPlanet.dat',/remove_all)
openr,1,StructuresPlanet_
readf,1,StructuresPlanet
close,1

thin=StructuresPlanet(*,0)
intermediate=StructuresPlanet(*,1)
thick=StructuresPlanet(*,2)
ALLPTS = [[thin], [intermediate], [thick]]
PLANET = findgen(nplanets)+1
N1 = N_ELEMENTS(PLANET) - 1
NAMES=['thin','intermediate', 'thick']
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load a color table:
 device,get_decompose=old_decomposed,decomposed=0
 LOADCT, 39
 Set_plot,'z'
 Device,Set_resolution=[640,400],Set_Pixel_Depth=24
 PLOT, planet, thick(*,*), YRANGE = [0, 8], $;[MIN(allpts),MAX(allpts)], $
    TITLE = 'Structures number in each planetary neighborhood', /NODATA, $
    XRANGE = [0.5, 7], charsize=1.25, background=255, color=0, $
    XTITLE= 'planet', YTITLE= 'structures', xtickinterval=1., ytickinterval=1.
 
 xyouts,460,320,strcompress('f ='+string(f)),charsize=1.5,charthick=1,color=0,/device
 xyouts,450,300,strcompress(string(nPlanets)+' planets'),charsize=1.5,charthick=1,color=0,/device
 xyouts,450,280,strcompress(string(ulong(output*1000.))+' years'),charsize=1.5,charthick=1,color=0,/device
 ; Get the y value of the bottom x-axis:
 minval = !Y.CRANGE[0]
 ; Create the bar chart:
 EX_BARGRAPH, minval
 write_png,strcompress(dischargeImagesFolder+'/StructuresByPlanet.png',$
                        /remove_all),tvrd(0,0,640,400,0,true=1);,tvrd(0,0,680,384,0,true=1)
  RETURN
end


