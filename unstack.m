function structure=unstack(vector, NumModes, tt)

% Unstack output vector
for kk=1:loads.NumModes+1
  structure.sk(kk)=vector(kk) + i * vector(NumModes+1+kk);
end
for kk=1:3
  structure.Sigma_p(tt,kk) = vector(2*NumModes+2+kk) ;
  structure.Eps_int(tt,kk) = vector(2*NumModes+5+kk) ;
end
