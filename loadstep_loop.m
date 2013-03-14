function [cohesive, displacement, loads, macro_var, potential, percentage, soln]= ...
    loadstep_loop(geom, material, loads, macro_var, soln, displacement, ...
                  cohesive, potential, percentage, inputname)


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
  
%   %TODO: Figure out proper scaling values
%   default_values = zeros(size(input_guess));
%   variance = ones(size(input_guess));

  [default_values, variance] = scaling_values(loads, material);
  scale = @(x) (x - default_values)./variance;
  unscale = @(x) x.*variance + default_values;

  while exitflag<=0                    
    % Convergence loop
    tic;
    counter=counter+1
    
    scaled_input_guess = scale(input_guess);
    % Solve for sk, Sigma_p, Eps_int    
    scaled_residuals = @(x) residual(unscale(x), loads, material, ...
                                     geom, step, tt, cohesive)./variance;
    
    guess_fval = scaled_residuals(scaled_input_guess);
    [scaled_output, scaled_fval, exitflag, optim_output] = fsolve(scaled_residuals, scaled_input_guess);
    output = unscale(scaled_output);
    fval = scaled_fval.*variance;
   
    converge.fval = fval;
    converge.guess_fval = guess_fval;
    converge.exitflag = exitflag;
    converge.ii = counter;
    converge.input_guess = input_guess;
    converge.output = output;
    converge.optim_output = optim_output;
    converge.time = toc;
    
    
    if exitflag ~= 1 
      if counter < loads.NumRestarts
        input_guess = (rand(size(input_guess)) ...
                       - 0.5)*material.sigmax*10;
      else
        break
      end  
    end
    
  
  end
  % end convergence loop
  
  soln.exitflag(tt) = exitflag;
  
  
  if exitflag ~= 1 
    output = output*0;
  end

  soln = unstack(output,loads.NumModes,tt,soln);

  
  % Calculate final values based on converged sk, sigma_p and eps_int
  %disp('Entering final')
  step = final(soln, loads, material, geom, step, tt, cohesive);

  
  % Write final step values to global values
  [cohesive, displacement, macro_var, potential, percentage] = ...
      finalize_timestep(step, cohesive, displacement, macro_var, ...
                        potential, percentage, loads, tt); 

  % Write output data for JSON
  
  output.loads = loads;
  output.material = material;
  output.geom = geom;
  output.converge = converge;
  output.step = step;
              
    
  outputname = [inputname '/strain_' num2str(loads.DriverStrain(tt)*10000) ...
                      '.json'];
  
  json = savejson('',output,outputname);
  
  
end      % end loop through loading steps


