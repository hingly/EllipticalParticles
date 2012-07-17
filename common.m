function [cohesive, disp]=common(N1, N2, omega, geom,  material,loads, sk)

% Given far-field loading and Fourier modes, compute cohesive tractions and displacements
% Created from residual.m 16/7/2012
% Put displacements and tractions in structures 17/7/2012


%-----------------------------
% Initialise arrays
%==============================

%constants
zero_intpoints=zeros(1,geom.NumPoints+1);

disp.farfield=zero_intpoints;
disp.farfield_xy=zero_intpoints;
disp.coh=zero_intpoints;
disp.coh_xy=zero_intpoints;
disp.total=zero_intpoints;
disp.total_xy=zero_intpoints;

cohesive.traction_xy=zero_intpoints;



%----------------------------------------
% Begin loop over integration points
%========================================

for kk=1:geom.NumPoints+1   
  % loop over all integration points
    
  %------------------------------------------------------
  % Compute potential functions from far-field loading 
  %======================================================
 
  [phi,phiprime,psi]=farfieldpotential(geom.theta(kk),geom.rho,geom.R, geom.m, N1, N2, omega);
        
  %-----------------------------------------------------
  % Compute displacements from far-field loading 
  %=====================================================
 
  disp.farfield(kk)=calculatedisplacement(phi, phiprime, psi, geom.theta(kk), material.mu_m, material.kappa_m, geom.m);
  disp.farfield_xy(kk)=disp.farfield(kk)*exp(i*geom.beta(kk));    
 
  %-------------------------------------------------------
  % Compute potential functions due to cohesive tractions
  %=======================================================

  [phicoh, phiprimecoh, psicoh]=modes(geom.theta(kk),geom.rho,geom.R, geom.m, loads.NumModes, sk);
  
  
  %-------------------------------------------------------
  % Compute cohesive displacements 
  %=======================================================
  
  disp.coh(kk)=calculatedisplacement(phicoh, phiprimecoh, psicoh, geom.theta(kk), material.mu_m, material.kappa_m, geom.m);
  disp.coh_xy(kk)=dispff(kk)*exp(i*geom.beta(kk));
  
end         
% end loop over integration points



%----------------------------------------------
% Compute total displacement
%==============================================


disp.total=disp.farfield+disp.coh;
disp.total_xy=disp.farfield_xy+disp.coh_xy;



%------------------------------------------------------
%Compute cohesive tractions resulting from displacement
%======================================================

cohesive=Cohesive_Law(disp.total,geom.NumPoints,material,cohesive.lambda_max);

% *** Not sure that we're storing previous value of lambda or
% *** calculating unloading correctly!!!

for kk=1:geom.NumPoints+1
    cohesive.traction_xy(kk)=cohesive.traction(kk)*exp(i*beta(kk));
end



