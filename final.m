function [cohesive,disp, loads]=final(soln, loads, material, geom)


% Given converged solution, including Fourier coefficients sk, the average particle stress
% Sigma_p and the interfacial strain Eps_int, this routine calculates displacements, stresses, 
% strains, cohesive tractions and cohesive damage 



%-----------------------------
% initialise arrays
%==============================

%constants
zero_intpoints=zeros(1,geom.NumPoints+1);

% FIXME : lambda needs to be handled more systematically
cohesive.lambda=zero_intpoints;
cohesive.lambda_xy=zero_intpoints;


        
%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed 
% from the given macroscopic strain eps_11.  Note that these depend on Sigma_p 
% and Eps_int, so must be re-calculated after convergence

[loads.MacroStress, loads.MacroStrain, loads.Sigma_m]= macrostress(loads.MacroStrain, Sigma_p, Eps_int, loads,geom, material);


%-----------------------------------------------
% Compute farfield loading
%===============================================


% Compute N1, N2 and omega for use as farfield stresses
[N1, N2, omega] = principal(loads.Sigma_m(1), loads.Sigma_m(2),loads.Sigma_m(3));



%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[cohesive,disp]=common(N1, N2, omega, geom, material,loads, sk)

% *** Completed to here 16/7/2012 - still need to deal with lambda in a sensible way

for kk=1:n+1
  U=real(disp.total(kk));
  V=imag(disp.total(kk));
  lambda(kk)=sqrt((U/delopen)^2+(V/delslide)^2);
  if real(disp(kk))<0
    lambda(kk)=0;
  end
  lambdaxy(kk)=lambda(kk)*exp(i*beta(kk));
  xy1(kk)=exp(i*beta(kk));
end





