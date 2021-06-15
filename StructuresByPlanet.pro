  BlockRad_mean=dblarr(TauRanges,Struct_max)

  for l=0,TauRanges-1 do begin
     for m=1,Block_prev[l] do begin
        BlockRad_mean[l,m]=(BlockRad_ini(l,m)+BlockRad_fin(l,m))/2.
;        print,BlockRad_mean[l,m]
     endfor
  endfor
  RplanetBorder=dblarr(nplanets+1)
  thin=dblarr(nplanets)
  intermediate=dblarr(nplanets)
  thick=dblarr(nplanets)
  RplanetBorder[0]=gapBorder[0]
  RplanetBorder[nplanets]=gapBorder[1]
;  BorderHill=dblarr(2)
;  BorderHill[0]=semieje[0]-(5*Hillplanet[0])
;  BorderHill[1]=semieje[nplanets-1]+(5*Hillplanet[nplanets-1])
;  RplanetBorder[0]=BorderHill[0]
;  RplanetBorder[nplanets]=BorderHill[1]
;  print,gapBorder[0],RplanetBorder[0]
;  print,gapBorder[1],RplanetBorder[nplanets]
  for i=1,nPlanets-1 do begin
     RplanetBorder[i]=(semieje[i]+semieje[i-1])/2.
  endfor
  if nplanets eq 2 then begin
     for l=0,TauRanges-1 do begin
        if l eq 0 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 thin[0]+=1
                 print,l,m,thin[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 thin[1]+=1
                 print,l,m,thin[1],BlockRad_mean[l,m]
              endif
           endfor
        endif
        if l eq 1 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 intermediate[0]+=1
                 print,l,m,intermediate[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 intermediate[1]+=1
                 print,l,m,intermediate[1],BlockRad_mean[l,m]
              endif
           endfor
        endif
        if l eq 2 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 thick[0]+=1
                 print,l,m,thick[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 thick[1]+=1
                 print,l,m,thick[1],BlockRad_mean[l,m]
              endif
           endfor
        endif
     endfor
  endif
 
 if nplanets eq 3 then begin
     for l=0,TauRanges-1 do begin
        if l eq 0 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 thin[0]+=1
                 print,l,m,thin[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 thin[1]+=1
                 print,l,m,thin[1],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[2]) and (BlockRad_mean[l,m] le RplanetBorder[3]) then begin
                 thin[2]+=1
                 print,l,m,thin[2],BlockRad_mean[l,m]
              endif
           endfor
        endif
        if l eq 1 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 intermediate[0]+=1
                 print,l,m,intermediate[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 intermediate[1]+=1
                 print,l,m,intermediate[1],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[2]) and (BlockRad_mean[l,m] le RplanetBorder[3]) then begin
                 intermediate[2]+=1
                 print,l,m,intermediate[2],BlockRad_mean[l,m]
              endif
           endfor
        endif
        if l eq 2 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 thick[0]+=1
                 print,l,m,thick[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 thick[1]+=1
                 print,l,m,thick[1],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[2]) and (BlockRad_mean[l,m] le RplanetBorder[3]) then begin
                 thick[2]+=1
                 print,l,m,thick[2],BlockRad_mean[l,m]
              endif
           endfor
        endif
     endfor
 endif
  
 if nplanets eq 4 then begin
     for l=0,TauRanges-1 do begin
        if l eq 0 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 thin[0]+=1
                 print,l,m,thin[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 thin[1]+=1
                 print,l,m,thin[1],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[2]) and (BlockRad_mean[l,m] le RplanetBorder[3]) then begin
                 thin[2]+=1
                 print,l,m,thin[2],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[3]) and (BlockRad_mean[l,m] le RplanetBorder[4]) then begin
                 thin[3]+=1
                 print,l,m,thin[3],BlockRad_mean[l,m]
              endif
           endfor
        endif
        if l eq 1 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 intermediate[0]+=1
                 print,l,m,intermediate[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 intermediate[1]+=1
                 print,l,m,intermediate[1],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[2]) and (BlockRad_mean[l,m] le RplanetBorder[3]) then begin
                 intermediate[2]+=1
                 print,l,m,intermediate[2],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[3]) and (BlockRad_mean[l,m] le RplanetBorder[4]) then begin
                 intermediate[3]+=1
                 print,l,m,intermediate[3],BlockRad_mean[l,m]
              endif
           endfor
        endif
        if l eq 2 then begin
           for m=1,Block_prev[l] do begin
              if (BlockRad_mean[l,m] ge RplanetBorder[0]) and (BlockRad_mean[l,m] le RplanetBorder[1]) then begin
                 thick[0]+=1
                 print,l,m,thick[0],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[1]) and (BlockRad_mean[l,m] le RplanetBorder[2]) then begin
                 thick[1]+=1
                 print,l,m,thick[1],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[2]) and (BlockRad_mean[l,m] le RplanetBorder[3]) then begin
                 thick[2]+=1
                 print,l,m,thick[2],BlockRad_mean[l,m]
              endif
              if (BlockRad_mean[l,m] ge RplanetBorder[3]) and (BlockRad_mean[l,m] le RplanetBorder[4]) then begin
                 thick[3]+=1
                 print,l,m,thick[3],BlockRad_mean[l,m]
              endif
           endfor
        endif
     endfor
 endif

openw,1,strcompress(dischargeImagesFolder+'/StructuresByPlanet.dat',/remove_all)
printf,1,thin,intermediate,thick
close,1


