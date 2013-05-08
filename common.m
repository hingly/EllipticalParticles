function [step] = common(N1, N2, omega, geom, material, loads, sk, step)

% Given far-field loading and Fourier modes, compute cohesive tractions and displacements
% Created from residual.m 16/7/2012
% Put displacements and tractions in structures 17/7/2012

%disp('Entering common...');


%------------------------------------------------------
% Compute potential functions from far-field loading 
%======================================================

[step.potential.phi,step.potential.phiprime,step.potential.psi]=farfieldpotential(geom.theta,geom.rho,geom.R, geom.m, N1, N2, omega);
        
%-----------------------------------------------------
% Compute displacements from far-field loading 
%=====================================================
 
step.displacement.farfield = ...
    calculatedisplacement(step.potential.phi, step.potential.phiprime,...
                          step.potential.psi, geom.theta, geom.m, material);
  
step.displacement.farfield_xy = step.displacement.farfield.*exp(i*geom.beta);    
 
%-------------------------------------------------------
% Compute potential functions due to cohesive tractions
%=======================================================
for kk = 1:length(geom.theta)
    [step.potential.phicoh(kk), step.potential.phiprimecoh(kk), ...
     step.potential.psicoh(kk)] = modes(geom.theta(kk), geom.rho, geom.R, geom.m, loads.NumModes, sk);
end  

%-------------------------------------------------------
% Compute displacements due to cohesive tractions
%=======================================================
  
step.displacement.coh = ...
    calculatedisplacement(step.potential.phicoh, step.potential.phiprimecoh, ...
                          step.potential.psicoh, geom.theta, geom.m, material);
step.displacement.coh_xy = step.displacement.coh.*exp(i*geom.beta);


%----------------------------------------------
% Compute total displacement
%==============================================

step.displacement.total = step.displacement.farfield + step.displacement.coh;
step.displacement.total_xy = step.displacement.farfield_xy + step.displacement.coh_xy;


%------------------------------------------------------
%Compute cohesive tractions resulting from displacement
%======================================================

step = Cohesive_Law(geom.NumPoints, material, step);


step.cohesive.traction_xy = step.cohesive.traction.*exp(i.*geom.beta);



