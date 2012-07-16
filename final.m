function [dispxy, dispffxy, dispcohxy, T_cohxy, lambda,lambdaxy, xy1, macstress, macstrain, sigmam]=...
    final(soln, loads, material, geom)


% Given converged solution, including Fourier coefficients sk, the average particle stress
% Sigma_p and the interfacial strain Eps_int, this routine calculates displacements, stresses, 
% strains, cohesive tractions and cohesive damage 



%-----------------------------
% initialise arrays
%==============================

% FIXME : I don't know what xy1 is, lambda needs to be handled more systematically
lambda=zeros(1,geom.NumPoints+1);
lambdaxy=zeros(1,geom.NumPoints+1);
%xy1=zeros(1,geom.NumPoints+1);


        
%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed from the given macroscopic strain eps_11
% Note that these depend on Sigma_p and Eps_int, so must be re-calculated after convergence

[loads.MacroStress, loads.MacroStrain, loads.Sigma_m]= macrostress(loads.MacroStrain, Sigma_p, Eps_int, loads,geom, material);


%-----------------------------------------------
% Compute farfield loading
%===============================================


% Compute N1, N2 and omega for use as farfield stresses
  [N1, N2, omega] = principal(loads.Sigma_m(1), loads.Sigma_m(2),loads.Sigma_m(3));



%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[T_coh, T_cohxy, disp, dispxy]=common(N1, N2, omega, geom, material,loads, sk)


% *** Completed to here 16/7/2012 - still need to deal with lambda in a sensible way

for kk=1:n+1
    lambda(kk)=Compute_lambda(real(disp(kk)), imag(disp(kk)),delopen,delslide);
    if real(disp(kk))<0
        lambda(kk)=0;
    end
    lambdaxy(kk)=lambda(kk)*exp(i*beta(kk));
    xy1(kk)=exp(i*beta(kk));
end





