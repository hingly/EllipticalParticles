function vector=stack(structure, NumModes, tt)

% Stacked input vector
vector=zeros(1,2*NumModes+8);
for kk=1:NumModes+1
  vector(kk)=real(structure.sk(tt,kk));
  vector(NumModes+1+kk) = imag(structure.sk(tt,kk));
end
for kk=1:3
  vector(2*NumModes+2+kk) = structure.Sigma_p(tt,kk);
  vector(2*NumModes+5+kk) = structure.Eps_int(tt,kk);
end
