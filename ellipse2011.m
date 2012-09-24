function [loads, displacement, cohesive, soln]=ellipse2011(filename)

if ~exist('filename', 'var')
  filename=input('Enter the complete input filename: ','s');
end

% This is the main driver code in the new improved 2011 version of the ellipse code.  

%------------------------------------------------------------------
% Read input data and create structures for main variables
%==================================================================

[material,geom,loads, post] = read_input(filename);

%------------------------------------------------------------------
% Calculate positions and angles at each point around the ellipse
%==================================================================

geom=calculate_geometry(geom);

%------------------------------------------------------------------
% Calculate loading variables
%==================================================================

[loads,soln,displacement,cohesive,potential,stepload,stepcoh]=initialize_loading(loads,geom,material);      
% Solution variables (sk, sigma_p and eps_int) are all stored in the soln structure


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
        for kk=1:2*loads.NumModes+8
          input_guess(kk)=output(kk)*(1+rand/100);
        end
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


% Write output data for JSON

output.cohesive = cohesive;
output.loads = loads;
output.displacement = displacement;
output.potential = potential;
output.soln = soln;
output.material = material;
output.geom = geom;

% FIXME : use string concatenation to make appropriate output file names

json = savejson('',output,'ellipse_output.json');

