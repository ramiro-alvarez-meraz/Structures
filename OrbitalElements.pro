Pro OrbitalElements

  f=10                           ;Accretion parameter
  nPlanets=2                    ;Number of planets

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

;  planet=dblarr(nPlanets)
  out=uint(out)
  outAsString = STRTRIM(out, 2)
;  spawn,'ls -l ~/ram_vogto/fargo/out'+outAsString+'/gasdens*.dat | wc -l',outputs
;  for j=1,1001 do begin
;     a=STRTRIM(j, 2)
;     if (a eq outputs) then outputs=j-1 ;Final output per out
;  endfor

  dischargeImagesFolder='~/Dropbox/visualization_tools/images/OrbitalElements/f'+string(f)+'_p'+string(nPlanets)
  dtDump=1000.
  if f eq 1 then begin
    outputs=350
    finalTime=outputs*dtDump
    xinterval=150000
  endif
  if f eq 10 then begin
    outputs=450
    finalTime=outputs*dtDump
    xinterval=200000
  endif
  if f eq 100 then begin
    outputs=1000
    finalTime=outputs*dtDump
    xinterval=500000
  endif
  time=findgen(outputs+1)*dtDump
print,finalTime
  device,get_decompose=old_decomposed,decomposed=0
  loadct,3

@PlanetAcc.pro
@PlanetMass.pro
@PlanetSemiMajorAxis.pro ;Causing Arithmetic error
@PlanetEccentricity.pro  ;Causing Arithmetic error

 RETURN
end
