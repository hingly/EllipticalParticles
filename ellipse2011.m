function ellipse2011(filename)

if ~exist('filename', 'var')
  filename=input('Enter the complete input filename: ','s');
end

% This is going to be the main driver code in the new improved 2011
% version of the ellipse code.  
% Hoorah!


%------------------------------------------------------------------
% Read input data and create structures for main variables
%==================================================================

[material,geom,loads] = read_input(filename);

%------------------------------------------------------------------
% Calculate positions and angles at each point around the ellipse
%==================================================================

geom=calculate_geometry(geom);

%------------------------------------------------------------------
% Calculate loading variables
%==================================================================

  [loads,soln,stepload]=initialize_loading(loads,geom);      %%%**** ----> Reached this point 14/9/2011 <--- **** &&&

% Solution variables (sk, sigma_p and eps_int) are all stored in the soln structure


%-----------------------------------------
% Begin loop through loadsteps
%=========================================


  for tt=1:loads.timesteps  % Loop through loading steps
	   
    %****  Notice: need to check that everything is getting
    %initialised/reset properly here! ****
        
    
    % FIXME: *** These should really be using the previous timestep value as a first guess

    % First guess for Sigma_p
	   % Sigma_p has the same shape as the imposed macroscopic stress,
           % sigma_p_11 is scaled by the imposed macroscopic strain

    if tt>1
      [soln, stepload] = incorporate_previous_timestep(soln, material, loads, tt);
    end
    
    % The complex fourier terms are  split into real and imaginary 
    % parts before going into the solution loop.  

    input=stack(loads, soln);
    

    %%%**** ----> Reached this point 29/9/2011 <--- **** &&&
    % ---> fixed stuff here 5/7/2012 <---- 
    
    exitflag=0;
    counter=0;
    
    while exitflag<=0                    % Convergence loop
        counter=counter+1;
        
        %****  Notice: need to check that everything is getting
        %initialised/reset properly here! ****
        
        
        
        % Solve for sk, Sigma_p, Eps_int
             %       options=optimset('Display','iter', 'TolFun',1e-5,
             %       'MaxFunEvals', 5000, 'MaxIter', 60);    % Option to display output
        [output,fval,exitflag]=fsolve(@(input) residual(input, steploads,loads, material, geom),input);

        
        if exitflag<=0
            if counter>2
                error('Non-converged solution')
            else
                for kk=1:2*loads.NumModes+8
                    input(kk)=output(kk)*(1+rand/100);
                end
            end
        end
        
    end
    
    % Unstack output vector
    for kk=1:loads.NumModes+1
        soln.sk(kk)=output(kk) + i * output(loads.NumModes+1+kk);
    end
    for kk=1:3
        soln.Sigma_p(tt,kk) = output(2*loads.NumModes+2+kk) ;
        soln.Eps_int(tt,kk) = output(2*loads.NumModes+5+kk) ;
    end

    % Write lambda_max_temp to lambda_max
    loads.lambda_max(tt,:) = lambda_max_temp;             %  Should this overwriting happen in final.m?  Should I do a comparison check or just copy over?  Not sure lambda_max_temp is actually available as a variable in this routine
    
    
	  
  end              % End loop through loading steps

