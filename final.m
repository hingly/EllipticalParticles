function [dispxy, dispffxy, dispcohxy, T_cohxy, lambda,lambdaxy, xy1, macstress, macstrain, sigmam]=...
    final(sk, sigmap, epsint, macstrain, E_m, nu_m, mu_m, kappa_m, f, alpha1, alpha2, rho, ...
    R, m, n, nmodes,theta1, beta, delopen, delslide, gint, lambda_e)


%initialise arrays
dispcoh=zeros(1,n+1);
dispff=zeros(1,n+1);
dispcohxy=zeros(1,n+1);
dispffxy=zeros(1,n+1);
T_cohxy=zeros(1,n+1);
lambda=zeros(1,n+1);
lambdaxy=zeros(1,n+1);
xy1=zeros(1,n+1);

            
            
% Compute macroscopic stresses corresponding to timestep in macroscopic
% strain
[macstress, macstrain(2), macstrain(3)]= macrostress(macstrain(1), sigmap, epsint, alpha1, alpha2, E_m, nu_m, f);

% Compute matrix stresses
sigmam = (macstress - f * sigmap)/(1-f);

%Compute N1, N2 and omega for use as farfield stresses
[N1, N2, omega] = principal(sigmam(1), sigmam(2),sigmam(3));




%-------------------------------------
% Begin loop over integration points
%=====================================

for kk=1:n+1    % loop over all integration points

    %------------------------------------------------------
    % Compute potential functions from far-field loading
    %======================================================

    [phi,phiprime,phiprime2,psi,psiprime]=farfieldpotential(theta1(kk),rho,R, m, N1, N2, omega);


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





