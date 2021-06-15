  for i=0,nrad-1 do begin
     for j=0,nsec-1 do begin
        tau=9.6*dens[j,i]*2./2.25*1.e7 ;Optical depth Troilita,etc.
        
;Optically thin:
        if (tau lt 0.5) then begin
           l=0
           Counter[i,l] += 1
           SigmaTau[i,l] += dens[j,i]
           DensTau[j,i,l]=dens[j,i]
        endif
        
;Optically transitional:
        if (tau ge 0.5) and (tau le 2.0) then begin
           l=1
           Counter[i,l] += 1
           SigmaTau[i,l]+=dens[j,i]
           DensTau[j,i,l]=dens[j,i]
        endif
        
;Optically thick:
        if (tau gt 2.0) then begin
           l=2
           Counter[i,l] += 1
           SigmaTau[i,l]+=dens[j,i]
           DensTau[j,i,l]=dens[j,i]
        endif
     endfor
  endfor

