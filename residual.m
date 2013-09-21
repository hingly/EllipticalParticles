function Rk = residual(input_guess, loads, material, geom, step, tt, ...
                       cohesive)



% Given a guess at the Fourier coefficients sk, the average particle stress
% sigmap and the interfacial strain epsint, this routine calculates the
% resulting cohesive coefficients skc and the corrected sigmap_new and
% epsint_new, and hences calculates the residual Rk


% Reset step structure at beginning of convergence iteration
step = reset_step(step, loads, tt, cohesive);


% Note that sigma_p, eps_int and sk are local variables during the convergence loop -
% passed as vector 'input'



%----------------------------------
% Unstack input vector
%==================================


dummy.Sigma_p=zeros(1,4);
dummy.Eps_int=zeros(1,3);
dummy.sk=zeros(1,loads.NumModes+1);

% Unstack input vector and separate into components
dummy=unstack(input_guess, loads.NumModes, 1,dummy);

Sigma_p=dummy.Sigma_p;
Eps_int=dummy.Eps_int;
sk = dummy.sk;



%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed from the given macroscopic strain eps_11
% Note that these depend on Sigma_p and Eps_int, so will be updated at every convergence step

[step.macro_var.MacroStress, step.macro_var.MacroStrain, step.macro_var.Sigma_m] = ...
    macrostress(step.macro_var.MacroStrain, Sigma_p, Eps_int, loads, geom, material);


%-----------------------------------------------
% Compute farfield loading
%===============================================

[N1, N2, omega] = principal(step.macro_var.Sigma_m(1), step.macro_var.Sigma_m(2),step.macro_var.Sigma_m(3));


%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[step]=common(N1, N2, omega, geom, material, loads, sk, step);


% Compute Fourier modes corresponding to cohesive tractions
skc = fouriertransform(step.cohesive.traction, geom.theta, loads.NumModes);

% Compute interfacial strain and average particle stress
[Sigma_p_new, Eps_int_new] = averages(step.displacement.total_xy, ...
                                      step.cohesive.traction_xy, geom);

%Sigma_p_new
%Sigma_p

% error in sk
error.sk=skc-sk;

% error in Sigma_p 
error.Sigma_p=Sigma_p_new - Sigma_p;  
% Extra equation to enforce symmetry of Sigma_p
error.Sigma_p(5) =  Sigma_p_new(3) - Sigma_p_new(4);

%error.Sigma_p

% error in Eps_int 
error.Eps_int=Eps_int_new - Eps_int;      

Rk=stack(error.sk, error.Sigma_p, error.Eps_int);


assert(isreal(Rk), 'Rk has complex components');


