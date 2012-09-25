function [stepcoh, stepdisp, steppot] = ...
    common(N1, N2, omega, geom, material, loads, sk,stepcoh)

% Given far-field loading and Fourier modes, compute cohesive tractions and displacements
% Created from residual.m 16/7/2012
% Put displacements and tractions in structures 17/7/2012

%disp('Entering common...');


%-----------------------------
% Initialise arrays
%==============================

%constants
zero_intpoints = zeros(1, geom.NumPoints);

stepdisp.farfield = zero_intpoints;
stepdisp.farfield_xy = zero_intpoints;
stepdisp.coh = zero_intpoints;
stepdisp.coh_xy = zero_intpoints;
stepdisp.total = zero_intpoints;
stepdisp.total_xy = zero_intpoints;

stepcoh.traction_xy = zero_intpoints;

steppot.phi = zero_intpoints;
steppot.phiprime = zero_intpoints;
steppot.psi = zero_intpoints;
steppot.phicoh = zero_intpoints;
steppot.phiprimecoh = zero_intpoints;
steppot.psicoh = zero_intpoints;




%----------------------------------------
% Begin loop over integration points
%========================================

for kk=1:geom.NumPoints   
  % loop over all integration points
    
  %------------------------------------------------------
  % Compute potential functions from far-field loading 
  %======================================================
 
  [steppot.phi(kk),steppot.phiprime(kk),steppot.psi(kk)]=farfieldpotential(geom.theta(kk),geom.rho,geom.R, geom.m, N1, N2, omega);
        
  %-----------------------------------------------------
  % Compute displacements from far-field loading 
  %=====================================================
 
  stepdisp.farfield(kk)=calculatedisplacement(steppot.phi(kk), steppot.phiprime(kk), steppot.psi(kk), geom.theta(kk), geom.m, material);
  stepdisp.farfield_xy(kk)=stepdisp.farfield(kk)*exp(i*geom.beta(kk));    
 
  %-------------------------------------------------------
  % Compute potential functions due to cohesive tractions
  %=======================================================

  [steppot.phicoh(kk), steppot.phiprimecoh(kk), steppot.psicoh(kk)]=modes(geom.theta(kk),geom.rho,geom.R, geom.m, loads.NumModes, sk);
  
  
  %-------------------------------------------------------
  % Compute displacements due to cohesive tractions
  %=======================================================
  
  stepdisp.coh(kk) = calculatedisplacement(steppot.phicoh(kk), steppot.phiprimecoh(kk), steppot.psicoh(kk), geom.theta(kk), geom.m, material);
  stepdisp.coh_xy(kk) = stepdisp.coh(kk)*exp(i*geom.beta(kk));
  
end         
% end loop over integration points



%----------------------------------------------
% Compute total displacement
%==============================================


stepdisp.total = stepdisp.farfield + stepdisp.coh;
stepdisp.total_xy = stepdisp.farfield_xy + stepdisp.coh_xy;



%------------------------------------------------------
%Compute cohesive tractions resulting from displacement
%======================================================

stepcoh = Cohesive_Law(stepdisp.total, geom.NumPoints, material,stepcoh);

%% Displacement jump must result in opposing traction
%stepcoh.traction = -stepcoh.traction;


stepcoh.traction_xy = stepcoh.traction.*exp(i.*geom.beta);



