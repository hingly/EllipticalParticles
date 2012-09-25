function [cohesive, displacement, loads, potential, soln]= ...
    loadstep_loop(geom, material, loads, soln, displacement, cohesive, ...
                  potential,stepload,stepcoh)


%-----------------------------------------
% Begin loop through loadsteps
%=========================================

for tt=1:loads.timesteps  % Loop through loading steps
  
  % FIXME : ****  Notice: need to check that everything is getting
  %initialised/reset properly here! ****
  
  disp('Beginning timestep...');
  loads.MacroStrain(tt,1)
  
  if tt>1
    [soln, stepload,stepcoh] = incorporate_previous_timestep(soln, material, loads, cohesive,tt);
  end
  
  % The complex fourier terms are  split into real and imaginary 
  % parts before going into the solution loop.  
  
  input_guess=stack(soln,loads.NumModes,tt);
  
  exitflag=0;
  counter=0;
  
  while exitflag<=0                    
    % Convergence loop
    
    counter=counter+1
    
    %****  Notice: need to check that everything is getting
    %initialised/reset properly here! ****
    
    
    
    % Solve for sk, Sigma_p, Eps_int
    %    options=optimset('Display','iter', 'TolFun',1e-5, 'MaxFunEvals', 5000, 'MaxIter', 60);    % Option to display output

    %    [output,fval,exitflag]=fsolve(@(input_guess) residual(input_guess, stepload,loads, material, geom,stepcoh),input_guess,options);
    
    [output,fval,exitflag]=fsolve(@(input_guess) residual(input_guess, stepload,loads, material, geom,stepcoh),input_guess);
    
    if exitflag<=0
      if counter>2
        error('Non-converged solution')
      else
        input_guess=output.*(1+rand(size(input_guess))/100)
      end
    end
    
  end
  % end convergence loop
  
  soln=unstack(output,loads.NumModes,tt,soln);

  % Calculate final values based on converged sk, sigma_p and eps_int
  [stepcoh, stepdisp, stepload, steppot]=final(soln, stepload,loads, material, geom,stepcoh,tt);

  % Write final step values to global values
  [cohesive, displacement, loads, potential]=finalize_timestep(stepcoh, stepdisp, stepload, steppot, cohesive, displacement, loads, potential,tt);

  % FIXME : finalize_timestep.m could be inside final.m

end      % end loop through loading steps


