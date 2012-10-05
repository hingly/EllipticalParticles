function [step] = common(N1, N2, omega, geom, material, loads, sk, step)

% Given far-field loading and Fourier modes, compute cohesive tractions and displacements
% Created from residual.m 16/7/2012
% Put displacements and tractions in structures 17/7/2012

%disp('Entering common...');


%----------------------------------------
% Begin loop over integration points
%========================================

for kk=1:geom.NumPoints   
  % loop over all integration points
    
  %------------------------------------------------------
  % Compute potential functions from far-field loading 
  %======================================================
 
  [step.potential.phi(kk),step.potential.phiprime(kk),step.potential.psi(kk)]=farfieldpotential(geom.theta(kk),geom.rho,geom.R, geom.m, N1, N2, omega);
        
  %-----------------------------------------------------
  % Compute displacements from far-field loading 
  %=====================================================
 
  step.displacement.farfield(kk) = ...
      calculatedisplacement(step.potential.phi(kk), step.potential.phiprime(kk),...
                            step.potential.psi(kk), geom.theta(kk), geom.m, material);
  
  step.displacement.farfield_xy(kk) = ...
      step.displacement.farfield(kk)*exp(i*geom.beta(kk));    
 
  %-------------------------------------------------------
  % Compute potential functions due to cohesive tractions
  %=======================================================

  [step.potential.phicoh(kk), step.potential.phiprimecoh(kk), ...
   step.potential.psicoh(kk)] = modes(geom.theta(kk),geom.rho, geom.R, geom.m, loads.NumModes, sk);
  

  %-------------------------------------------------------
  % Compute displacements due to cohesive tractions
  %=======================================================
  
  step.displacement.coh(kk) = ...
      calculatedisplacement(step.potential.phicoh(kk), step.potential.phiprimecoh(kk), ...
                            step.potential.psicoh(kk), geom.theta(kk), geom.m, material);
  step.displacement.coh_xy(kk) = step.displacement.coh(kk)*exp(i*geom.beta(kk));
  
end         
% end loop over integration points



%----------------------------------------------
% Compute total displacement
%==============================================


step.displacement.total = step.displacement.farfield + step.displacement.coh;
step.displacement.total_xy = step.displacement.farfield_xy + step.displacement.coh_xy;


%------------------------------------------------------
%Compute cohesive tractions resulting from displacement
%======================================================

step = Cohesive_Law(geom.NumPoints, material, step);

%% Displacement jump must result in opposing traction
%step.cohesive.traction = -step.cohesive.traction;


step.cohesive.traction_xy = step.cohesive.traction.*exp(i.*geom.beta);



