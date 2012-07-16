function Rk=residual(input,steploads,loads, material, geom)



% Given a guess at the Fourier coefficients sk, the average particle stress
% sigmap and the interfacial strain epsint, this routine calculates the
% resulting cohesive coefficients skc and the corrected sigmap_new and
% epsint_new, and hences calculates the residual Rk


  % Note that sigma_p, eps_int and sk are local variables during the convergence loop -
  % passed as vector 'input'





%----------------------------------
% Unstack input vector
%==================================

% FIXME : Use unstack subroutine

% Initialise vectors
Sigma_p=zeros(1,3);
Eps_int=zeros(1,3);
sk = zeros(1,loads.NumModes+1);

% Copy from input vector
for kk=1:loads.NumModes+1
    sk(kk)=input(kk)+ i* input(loads.NumModes+1+kk);
end
for kk=1:3
    Sigma_p(kk) = input(2*loads.NumModes+2+kk) ;
    Eps_int(kk) = input(2*loads.NumModes+5+kk) ;
end




%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed from the given macroscopic strain eps_11
% Note that these depend on Sigma_p and Eps_int, so will be updated at every convergence step

[steploads.MacroStress, steploads.MacroStrain, steploads.Sigma_m]= macrostress(steploads.MacroStrain, Sigma_p, Eps_int, loads,geom, material);


%-----------------------------------------------
% Compute farfield loading
%===============================================

[N1, N2, omega] = principal(steploads.Sigma_m(1), steploads.Sigma_m(2),steploads.Sigma_m(3));
  
%-------------------> Completed to here Apr 10 6:27


%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[T_coh, T_cohxy, disp, dispxy]=common(N1, N2, omega, geom, material,loads, sk)


% Compute Fourier modes corresponding to cohesive tractions

% --- T_coh is a vector NumPoints+1 long, containing a cohesive  traction at each integration point.  
skc=fouriertransform(T_coh,geom.theta,geom.NumPoints,loads.NumModes);

% Compute interfacial strain and average particle stress
[Sigma_p_new, Eps_int_new] = averages(dispxy, T_cohxy, geom);

%-------------------> Completed to here July 3 2012 but
%                               not documented in xls file


errorskreal = real(skc-sk);
errorskimag = imag(skc-sk);                    
% error in sk (1,geom.NumPoints+1)

errorsig=Sigma_p_new - Sigma_p;      
% error in Sigma_p (1,3)

erroreps=Eps_int_new - Eps_int;      
% error in Eps_int (1,3)


% FIXME : use stack subroutine

% Stacked residual vector
Rk=zeros(1,2*loads.NumModes+8); 
for kk=1:loads.NumModes+1
    Rk(kk)=errorskreal(kk);
    Rk(loads.NumModes+1+kk) = errorskimag(kk);
end
for kk=1:3
    Rk(2*loads.NumModes+2+kk) = errorsig(kk);
    Rk(2*loads.NumModes+5+kk) = erroreps(kk);
end

Rk = real(Rk);


