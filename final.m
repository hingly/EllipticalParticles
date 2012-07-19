function [stepcoh,stepdisp, stepload]=final(soln, loads, material, geom)


% Given converged solution, including Fourier coefficients sk, the average particle stress
% Sigma_p and the interfacial strain Eps_int, this routine calculates displacements, stresses, 
% strains, cohesive tractions and cohesive damage 



%-----------------------------
% initialise arrays
%==============================

%constants
zero_intpoints=zeros(1,geom.NumPoints+1);

% FIXME : lambda needs to be handled more systematically
stepcoh.lambda=zero_intpoints;
stepcoh.lambda_xy=zero_intpoints;



        
%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed 
% from the given macroscopic strain eps_11.  Note that these depend on Sigma_p 
% and Eps_int, so must be re-calculated after convergence

[stepload.MacroStress, stepload.MacroStrain, stepload.Sigma_m]= macrostress(stepload.MacroStrain, Sigma_p, Eps_int, loads,geom, material);


%-----------------------------------------------
% Compute farfield loading
%===============================================


% Compute N1, N2 and omega for use as farfield stresses
[N1, N2, omega] = principal(loads.Sigma_m(1), loads.Sigma_m(2),loads.Sigma_m(3));



%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[stepcoh,stepdisp]=common(N1, N2, omega, geom, material,loads, sk)

% *** Completed to here 16/7/2012 - still need to deal with lambda in a sensible way

for kk=1:n+1
  U=real(stepdisp.total(kk));
  V=imag(stepdisp.total(kk));
  stepcoh.lambda(kk)=sqrt((U/delopen)^2+(V/delslide)^2);
  if real(stepdisp(kk))<0
    stepcoh.lambda(kk)=0;
  end
  stepcoh.lambda_xy(kk)=stepcoh.lambda(kk)*geom.normal(kk));
end





