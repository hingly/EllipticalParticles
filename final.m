function [stepcoh,stepdisp, stepload,steppot]=final(soln, stepload,loads, material, geom,stepcoh,tt)


% Given converged solution, including Fourier coefficients sk, the average particle stress
% Sigma_p and the interfacial strain Eps_int, this routine calculates displacements, stresses, 
% strains, cohesive tractions and cohesive damage 


disp('Entering final...');
%-----------------------------
% initialise arrays
%==============================

%constants
zero_intpoints=zeros(1,geom.NumPoints+1);

stepcoh.lambda_xy=zero_intpoints;



        
%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed 
% from the given macroscopic strain eps_11.  Note that these depend on Sigma_p 
% and Eps_int, so must be re-calculated after convergence

[stepload.MacroStress, stepload.MacroStrain, stepload.Sigma_m]= macrostress(stepload.MacroStrain, soln.Sigma_p(tt,:), soln.Eps_int(tt,:), loads,geom, material);


%-----------------------------------------------
% Compute farfield loading
%===============================================


% Compute N1, N2 and omega for use as farfield stresses
[N1, N2, omega] = principal(loads.Sigma_m(1), loads.Sigma_m(2),loads.Sigma_m(3));



%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[stepcoh,stepdisp,steppot]=common(N1, N2, omega, geom, material,loads, soln.sk(tt,:),stepcoh);

% *** Completed to here 16/7/2012 - still need to deal with lambda in a sensible way

for kk=1:geom.NumPoints+1
  if real(stepdisp.total(kk))<0
    stepcoh.lambda(kk)=0;
% CHECK : This is for display purposes - not sure it's right to be doing
  end
  stepcoh.lambda_xy(kk)=stepcoh.lambda(kk)*geom.normal(kk);
  
  % Write lambda_max_temp and loading_temp to lambda_max and
  % loading at end of convergence loop
  stepcoh.lambda_max=stepcoh.lambda_max_temp;
  stepcoh.loading=stepcoh.loading_temp;
  
end





