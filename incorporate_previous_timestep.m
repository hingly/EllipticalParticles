function [soln, step] = ...
    incorporate_previous_timestep(soln, material, loads, cohesive, tt)

soln.Sigma_p(tt,:) = soln.Sigma_p(tt-1,:);
soln.Eps_int(tt,:) = soln.Eps_int(tt-1,:);
soln.sk(tt,:)=soln.sk(tt-1,:);

step.cohesive.lambda_max=cohesive.lambda_max(tt-1,:);
step.cohesive.loading=cohesive.loading(tt-1,:);
step.macro_var.MacroStrain(1)=loads.DriverStrain(tt);
