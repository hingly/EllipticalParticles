function [dispxy, dispffxy, dispcohxy, T_cohxy, lambda,lambdaxy, xy1, macstress, macstrain, sigmam]=...
    final(soln, loads, material, geom)


% Given converged solution, including Fourier coefficients sk, the average particle stress
% Sigma_p and the interfacial strain Eps_int, this routine calculates displacements, stresses, 
% strains, cohesive tractions and cohesive damage 



%-----------------------------
% initialise arrays
%==============================

% FIXME : **** Note I want to think about a structure for these guys too***
dispcoh=zeros(1,geom.NumPoints+1);
dispff=zeros(1,geom.NumPoints+1);
dispcohxy=zeros(1,geom.NumPoints+1);
dispffxy=zeros(1,geom.NumPoints+1);
T_cohxy=zeros(1,geom.NumPoints+1);


% FIXME : I don't know what xy1 is, lambda needs to be handled more systematically
lambda=zeros(1,geom.NumPoints+1);
lambdaxy=zeros(1,geom.NumPoints+1);
xy1=zeros(1,geom.NumPoints+1);


        
%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed from the given macroscopic strain eps_11
% Note that these depend on Sigma_p and Eps_int, so must be re-calculated after convergence

[loads.MacroStress, loads.MacroStrain, loads.Sigma_m]= macrostress(loads.MacroStrain, Sigma_p, Eps_int, loads,geom, material);

% Compute N1, N2 and omega for use as farfield stresses
  [N1, N2, omega] = principal(loads.Sigma_m(1), loads.Sigma_m(2),loads.Sigma_m(3));



%-------------------------------------
% Begin loop over integration points
%=====================================

for kk=1:n+1    
  % loop over all integration points

  %------------------------------------------------------
  % Compute potential functions from far-field loading
  %======================================================
  
  [phi,phiprime,phiprime2,psi,psiprime]=farfieldpotential(geom.theta(kk),geom.rho,geom.R, geom.m, N1, N2, omega);
  
% FIXME : Only need to calculate phiprime2, psiprime when we are
  % calculating stress - i.e. in final.   Separate these subroutines
  


    %-----------------------------------------------------
    % Compute displacements from far-field loading
    %=====================================================

    dispff(kk)=calculatedisplacement(phi, phiprime, psi, theta1(kk), mu_m, kappa_m, m);
    dispffxy(kk)=dispff(kk)*exp(i*beta(kk));



    %-------------------------------------------------------
    % Compute potential functions due to cohesive tractions
    %=======================================================

    [phicoh, phiprimecoh, psicoh]=modes(theta1(kk),rho,R, m, nmodes, sk);


    %-------------------------------------------------------
    % Compute cohesive displacements
    %=======================================================

    dispcoh(kk)=calculatedisplacement(phicoh, phiprimecoh, psicoh, theta1(kk), mu_m, kappa_m, m);
    dispcohxy(kk)=dispcoh(kk)*exp(i*beta(kk));

end         % end loop over integration points


%----------------------------------------------
% Compute total displacement
%==============================================


disp=dispff+dispcoh;
dispxy=dispffxy+dispcohxy;



%------------------------------------------------------
%Compute cohesive tractions resulting from displacement
%======================================================

T_coh=cohesivetractions(disp,n,delopen,delslide,gint,lambda_e);

for kk=1:n+1
    T_cohxy(kk)=T_coh(kk)*exp(i*beta(kk));
    lambda(kk)=Compute_lambda(real(disp(kk)), imag(disp(kk)),delopen,delslide);
    if real(disp(kk))<0
        lambda(kk)=0;
    end
    lambdaxy(kk)=lambda(kk)*exp(i*beta(kk));
    xy1(kk)=exp(i*beta(kk));
end





