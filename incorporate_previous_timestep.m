function [soln, stepload] = incorporate_previous_timestep(soln, material, loads, tt)
soln.Sigma_p(tt,:) = soln.Sigma_p(tt-1,:);
soln.Eps_int(tt,:) = soln.Eps_int(tt-1,:);
soln.sk(tt,:)=soln.sk(tt-1,:);

stepload.lambda_max=loads.lambda_max(tt-1,:);
stepload.MacroStrain(1)=loads.MacroStrain(tt,1);
