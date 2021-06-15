Pro StructuresEmision
;We follow the tutorial steps to begin this script, except the first.
;Here, previously, we must had been run the Structures.pro script
;with the following f, nPlanets and output parameters in order to
;produce the emision structures requested.
 
  f=1                           ;Accretion parameter
  nPlanets=2                   ;Number of planets
  output=50                    ;The output

;Read the correct out
  if f eq 1 and nPlanets eq 2 then out=8
  if f eq 1 and nPlanets eq 3 then out=10
  if f eq 1 and nPlanets eq 4 then out=11
  if f eq 10 and nPlanets eq 2 then out=14
  if f eq 10 and nPlanets eq 3 then out=12
  if f eq 10 and nPlanets eq 4 then out=13
  if f eq 100 and nPlanets eq 2 then out=9
  if f eq 100 and nPlanets eq 3 then out=16
  if f eq 100 and nPlanets eq 4 then out=17
  dataFolder='~/ram_vogto/fargo/out'+string(out)

;@home/ramiro/ram_vogto/radmc-3d/version_0.27/examples/run_ppdisk_gui/fargo2radmc.pro
path=filepath('fargo2radmc.pro',root_dir=['/'],subdirectory=['home','ramiro','ram_vogto','radmc-3d','version_0.27','examples','run_ppdisk_gui'],/tmp)
@temp
 RETURN
end
