function [step] = final(soln, loads, material, geom, step, tt, cohesive)


% Given converged solution, including Fourier coefficients sk, the average particle stress
% Sigma_p and the interfacial strain Eps_int, this routine calculates displacements, stresses, 
% strains, cohesive tractions and cohesive damage 


%disp('Entering final...');

% Reset step structure at beginning of convergence iteration
step = reset_step(step, loads, tt, cohesive);
        
%-----------------------------------------------
% Compute macroscopic stresses and strains
%===============================================

% Macroscopic stresses and strains for the current timestep are computed 
% from the given macroscopic strain eps_11.  Note that these depend on Sigma_p 
% and Eps_int, so must be re-calculated after convergence

soln.Sigma_p(tt,:)
%soln.Eps_int(tt,:)
[step.macro_var.MacroStress, step.macro_var.MacroStrain, step.macro_var.Sigma_m]= ...
    macrostress(step.macro_var.MacroStrain, soln.Sigma_p(tt,:), soln.Eps_int(tt,:), loads, geom, material);


step.macro_var.MacroStrain_trans = stress_transformation(step.macro_var.MacroStrain,loads.AppliedLoadAngle);
step.macro_var.MacroStress_trans = stress_transformation(step.macro_var.MacroStress,loads.AppliedLoadAngle);

%-----------------------------------------------
% Compute farfield loading
%===============================================


% Compute N1, N2 and omega for use as farfield stresses
[N1, N2, omega] = principal(step.macro_var.Sigma_m(1), step.macro_var.Sigma_m(2),step.macro_var.Sigma_m(3));


%-----------------------------------------------
% Compute displacements and cohesive tractions
%===============================================

[step] = common(N1, N2, omega, geom, material, loads, soln.sk(tt,:), step);


for kk=1:geom.NumPoints
  % Calculate a vector lambda_xy with magnitude lambda in the
  % direction of the normal vector
  step.cohesive.lambda_xy(kk)=step.cohesive.lambda(kk)*geom.normal(kk);
  
  % Write lambda_max_temp and loading_temp to lambda_max and
  % loading at end of convergence loop
  step.cohesive.lambda_max=step.cohesive.lambda_max_temp;
  step.cohesive.loading=step.cohesive.loading_temp;
end


% Calculate percentages
step.percentage = calculate_percentages(geom, material, step.cohesive, step.displacement);


warningflag = true;
%Check averages for error in Sigma_p
[Sigma_p_new, Eps_int_new, Symm_error] = averages(step.displacement.total_xy, ...
                                      step.cohesive.traction_xy, geom, warningflag);

Sigma_p_new
%Eps_int_new
Symm_error

step.symm_error = Symm_error;


