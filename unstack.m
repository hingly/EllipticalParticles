function soln=unstack(output, loads, tt)

% Unstack output vector
for kk=1:loads.NumModes+1
  soln.sk(kk)=output(kk) + i * output(loads.NumModes+1+kk);
end
for kk=1:3
  soln.Sigma_p(tt,kk) = output(2*loads.NumModes+2+kk) ;
  soln.Eps_int(tt,kk) = output(2*loads.NumModes+5+kk) ;
end
