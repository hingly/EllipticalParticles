function [cohesive, displacement, loads, macro_var, potential, soln]= ...
    loadstep_loop(geom, material, loads, macro_var, soln, displacement, ...
                  cohesive, potential)


% Allocate step structures 

  step = initialize_step_variables(loads, geom);

%-----------------------------------------
% Begin loop through loadsteps
%=========================================

for tt=1:loads.timesteps  % Loop through loading steps
  
  disp(['Beginning timestep ' num2str(tt) ' of ' num2str(loads.timesteps) ...
        ' with macroscopic strain = ' num2str(loads.DriverStrain(tt))]);
  

  
  % The complex fourier terms are  split into real and imaginary 
  % parts before going into the solution loop.  
  if tt>1
    input_guess = stack(soln.sk(tt-1,:), soln.Sigma_p(tt-1,:), ...
                        soln.Eps_int(tt-1,:));
  else
    assert(tt == 1, 'Something funny happening here');
    input_guess = stack(soln.sk(tt,:), soln.Sigma_p(tt,:), ...
                        soln.Eps_int(tt,:));    
  end
  
  exitflag=0;
  counter=0;
  
  while exitflag<=0                    
    % Convergence loop
    
    counter=counter+1
    
    
    % Solve for sk, Sigma_p, Eps_int    
    [output,fval,exitflag] = ...
        fsolve(@(input_guess) residual(input_guess, loads, material, ...
                                       geom, step, tt, cohesive), input_guess);
    
    if exitflag<=0 
      if counter < loads.NumRestarts
        input_guess=output.*(1+rand(size(input_guess))/100)
      else
        break
      end
      
    end
    
    
  end
  % end convergence loop
  
  soln.exitflag = exitflag;
  
  if exitflag<=0 
    break
  end
  
  soln = unstack(output,loads.NumModes,tt,soln);
  
  % Calculate final values based on converged sk, sigma_p and eps_int
  step = final(soln, loads, material, geom, step, tt, cohesive);

  % Write final step values to global values
  [cohesive, displacement, macro_var, potential] = ...
      finalize_timestep(step, cohesive, displacement, macro_var, loads, potential,tt);

end      % end loop through loading steps


