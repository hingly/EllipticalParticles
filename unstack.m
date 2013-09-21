function structure=unstack(vector, NumModes, tt, structure)

% Unstack output vector
kk=1:NumModes+1;
structure.sk(tt,kk)=vector(kk) + i * vector(NumModes+1+kk);
kk=1:3;
structure.Sigma_p(tt,kk) = vector(2*NumModes+2+kk) ;
kk=1:3;
structure.Eps_int(tt,kk) = vector(2*NumModes+5+kk) ;
