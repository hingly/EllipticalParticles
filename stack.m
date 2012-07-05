function input=stack(soln, loads,tt)

% Stacked input vector
input=zeros(1,2*loads.NumModes+8);
for kk=1:loads.NumModes+1
  input(kk)=real(soln.sk(tt,kk));
  input(loads.NumModes+1+kk) = imag(soln.sk(tt,kk));
end
for kk=1:3
  input(2*loads.NumModes+2+kk) = soln.Sigma_p(tt,kk);
  input(2*loads.NumModes+5+kk) = soln.Eps_int(tt,kk);
end
