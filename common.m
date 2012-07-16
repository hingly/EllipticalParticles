function [T_coh, T_cohxy, disp, dispxy]=common(N1, N2, omega, geom,  material,loads, sk)

% Given far-field loading and Fourier modes, compute cohesive tractions and displacements
% Created from residual.m 16/7/2012


%-----------------------------
% Initialise arrays
%==============================

dispcoh=zeros(1,geom.NumPoints+1);
dispff=zeros(1,geom.NumPoints+1);
dispcohxy=zeros(1,geom.NumPoints+1);
dispffxy=zeros(1,geom.NumPoints+1);
T_cohxy=zeros(1,geom.NumPoints+1);
% FIXME :  I want these guys to be in a structure



%----------------------------------------
% Begin loop over integration points
%========================================

for kk=1:geom.NumPoints+1   
  % loop over all integration points
    
  %------------------------------------------------------
  % Compute potential functions from far-field loading 
  %======================================================
 
  [phi,phiprime,psi]=farfieldpotential(geom.theta(kk),geom.rho,geom.R, geom.m, N1, N2, omega);
    
  
  %-------------------> Completed to here Oct 13 2011 but not fully
  %                     documented in xls file
    
  %-----------------------------------------------------
  % Compute displacements from far-field loading 
  %=====================================================
 
  dispff(kk)=calculatedisplacement(phi, phiprime, psi, geom.theta(kk), material.mu_m, material.kappa_m, geom.m);
  dispffxy(kk)=dispff(kk)*exp(i*geom.beta(kk));
    
  %-------------------> Completed to here Dec 2 2011 but not fully
  %                     documented in xls file
  
  %-------------------------------------------------------
  % Compute potential functions due to cohesive tractions
  %=======================================================

  [phicoh, phiprimecoh, psicoh]=modes(geom.theta(kk),geom.rho,geom.R, geom.m, loads.NumModes, sk);
  
  
  %-------------------------------------------------------
  % Compute cohesive displacements 
  %=======================================================
  
  dispcoh(kk)=calculatedisplacement(phicoh, phiprimecoh, psicoh, geom.theta(kk), material.mu_m, material.kappa_m, geom.m);
  dispcohxy(kk)=dispff(kk)*exp(i*geom.beta(kk));
  
end         
% end loop over integration points

%-------------------> Completed to here March 12 2012 but not fully
%                     documented in xls file



%----------------------------------------------
% Compute total displacement
%==============================================


disp=dispff+dispcoh;
dispxy=dispffxy+dispcohxy;



%------------------------------------------------------
%Compute cohesive tractions resulting from displacement
%======================================================

T_coh=Cohesive_Law(disp,geom.NumPoints,material,stepload.lambda_max);

% *** Not sure that we're storing previous value of lambda or
% *** calculating unloading correctly!!!

for kk=1:geom.NumPoints+1
    T_cohxy(kk)=T_coh(kk)*exp(i*beta(kk));
end



% -----------------> Updated cohesive law subroutine 4/7/2012, not
%                              fully documented in xls file
