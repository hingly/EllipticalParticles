function Rk=residual(input,steploads,loads, material, geom)



% Given a guess at the Fourier coefficients sk, the average particle stress
% sigmap and the interfacial strain epsint, this routine calculates the
% resulting cohesive coefficients skc and the corrected sigmap_new and
% epsint_new, and hences calculates the residual Rk


  % Note that sigma_p, eps_int and sk are local variables during the convergence loop -
  % passed as vector 'input'





%----------------------------------
% Unstack input vector
%==================================

% Initialise vectors
Sigma_p=zeros(1,3);
Eps_int=zeros(1,3);
sk = zeros(1,loads.NumModes+1);

% Copy from input vector
for kk=1:loads.NumModes+1
    sk(kk)=input(kk)+ i* input(loads.NumModes+1+kk);
end
for kk=1:3
    Sigma_p(kk) = input(2*loads.NumModes+2+kk) ;
    Eps_int(kk) = input(2*loads.NumModes+5+kk) ;
end

%-----------------------------
% initialise arrays
%==============================

dispcoh=zeros(1,geom.NumPoints+1);
dispff=zeros(1,geom.NumPoints+1);
dispcohxy=zeros(1,geom.NumPoints+1);
dispffxy=zeros(1,geom.NumPoints+1);
T_cohxy=zeros(1,geom.NumPoints+1);

% FIXME: **** Note I want to think about a structure for these guys too***




%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

  % Macroscopic stresses and strains for the current timestep are computed from the given macroscopic strain eps_11
  % Note that these depend on Sigma_p and Eps_int, so will be updated at every convergence step

  steploads= macrostress(steploads, Sigma_p, Eps_int, loads,geom);



% Compute N1, N2 and omega for use as farfield stresses
  [N1, N2, omega] = principal(steploads.Sigma_m(1), steploads.Sigma_m(2),steploads.Sigma_m(3));

%-------------------> Completed to here Apr 10 6:27


%----------------------------------------
% Begin loop over integration points
%========================================

for kk=1:geom.NumPoints+1   
  % loop over all integration points
    
  %------------------------------------------------------
  % Compute potential functions from far-field loading 
  %======================================================
 
  [phi,phiprime,phiprime2,psi,psiprime]=farfieldpotential(geom.theta(kk),geom.rho,geom.R, geom.m, N1, N2, omega);
    
  % FIXME: Only need to calculate phiprime2, psiprime when we are
  % calculating stress - i.e. in final  separate these subroutines
  
  
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


% Compute Fourier modes corresponding to cohesive tractions

% --- T_coh is a vector NumPoints+1 long, containing a cohesive  traction at each integration point.  
skc=fouriertransform(T_coh,geom.theta,geom.NumPoints,loads.NumModes);

% Compute interfacial strain and average particle stress
[Sigma_p_new, Eps_int_new] = averages(dispxy, T_cohxy, geom);

%-------------------> Completed to here July 3 2012 but
%                               not documented in xls file


errorskreal = real(skc-sk);
errorskimag = imag(skc-sk);                    
% error in sk (1,geom.NumPoints+1)
errorsig=Sigma_p_new - Sigma_p;      
% error in Sigma_p (1,3)
erroreps=Eps_int_new - Eps_int;      
% error in Eps_int (1,3)


% Stacked residual vector
Rk=zeros(1,2*loads.NumModes+8); 
for kk=1:loads.NumModes+1
    Rk(kk)=errorskreal(kk);
    Rk(loads.NumModes+1+kk) = errorskimag(kk);
end
for kk=1:3
    Rk(2*loads.NumModes+2+kk) = errorsig(kk);
    Rk(2*loads.NumModes+5+kk) = erroreps(kk);
end

Rk = real(Rk);


