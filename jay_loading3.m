function jay_loading3


  epsilon = 1e-5;
  plotflag = true;



% -------------------------
%        INPUT
%==========================

% Required parameters
  material.plstrain = 1;
  material.cohscale = 1;

  post.scale = 1;

  loads.NumModes = 30;
  loads.NumRestarts = 0;

  geom.NumPoints = 60;

  NumGuesses = 10;

% Generate random numbers between -10 and 10 to use as input guesses
% (sigmax is 1 for comparison)
  random_guess = (rand(NumGuesses, 2*loads.NumModes + 8) - 0.5)*20; 

% Chosen parameters for testing
  ratiolist = [0 0.5 1 -0.5 -1]; 
  strainlist = [linspace(0.0004, 0.04, 100)];

  
  for ratio = ratiolist
    
    if abs(ratio) < epsilon
      rationame = 'uni';
    elseif abs(ratio - 0.5) < epsilon
      rationame = 'half';
    elseif abs(ratio - 1) < epsilon
      rationame = 'equi';
    elseif abs(ratio + 0.5) < epsilon
      rationame = 'neghalf';
    elseif abs(ratio + 1) < epsilon
      rationame = 'shear';  
    end
    
    for strain = strainlist
      for ii = 1:NumGuesses      
	
	tic;
	disp(['Strain is ' num2str(strain) ' guess ' num2str(ii)]);
	
	loads.SigmaBarRatio = ratio;
	loads.AppliedLoadAngle = 0;
	
	material.sigmax = 20;
        material.delopen = 0.5;
        material.lambda_e = 0.001;
        material.nu_m = 0.35;

        geom.f = 0.4; 

        loads.timesteps = 1;
        loads.MinimumStrain = strain;

% Proportional parameters
        R = 90;
        geom.a = R;
        geom.b = R;
        material.E_m = 4300;
        loads.LoadFactor = loads.timesteps;

%---------------------------------
% Check validity of input data
%=================================
        
        check_geom(geom,loads);
        check_material(material);
        
        loads.SigmaBar1 = 1;  
        
%---------------------------------------------------------
% Calculate additional material parameters
%---------------------------------------------------------

        material = calculate_material(material);

	%------------------------------------------------------------------
	% Calculate positions and angles at each point around the ellipse
	%==================================================================

        geom = calculate_geometry(geom);

	%------------------------------------------------------------------
	% Initialize global variables
	%==================================================================

        [loads, macro_var, displacement, cohesive, potential, soln] = ...
            initialize_global_variables(loads, geom, material);   

	% Calculate stress ratios for imposed stress
        loads = calculate_imposed_stress(loads);

	% Solution variables (sk, sigma_p and eps_int) are all stored in
	% the soln structure. Guess for the first timestep

        input_guess = random_guess(ii,:);

        step = initialize_step_variables(loads, geom);

	%-----------------------------------------
	% Begin loop through loadsteps
	%=========================================

        tt = 1;          
        exitflag=0;
        
        [default_values, variance] = scaling_values(loads, material);
        scale = @(x) (x - default_values)./variance;
        unscale = @(x) x.*variance + default_values;
        
        scaled_input_guess = scale(input_guess);
	% Solve for sk, Sigma_p, Eps_int    
        scaled_residuals = @(x) residual(unscale(x), loads, material, ...
                                         geom, step, tt, cohesive)./variance;
        
        guess_fval = scaled_residuals(scaled_input_guess);
        [scaled_output, scaled_fval, exitflag, optim_output] = ...
            fsolve(scaled_residuals, scaled_input_guess);
        output = unscale(scaled_output);
        fval = scaled_fval.*variance;
        
        soln.exitflag = exitflag;

        soln = unstack(output,loads.NumModes,tt,soln);
        

        guess_test.fval = fval;
        guess_test.guess_fval = guess_fval;
        guess_test.exitflag = exitflag;
        guess_test.ii = ii;
        guess_test.input_guess = input_guess;
        guess_test.output = output;
        guess_test.optim_output = optim_output;
        guess_test.time = toc;
        
        

	% Write output data for JSON

        output.loads = loads;
        output.material = material;
        output.geom = geom;
        output.guess_test = guess_test;
        output.soln = soln;
     
	% FIXME : use string concatenation to make appropriate output file names

        filename = strcat(['Jay/compare/jayrun_' num2str(ii) '_strain_' ...
                           num2str(strain*10000) '_E_' num2str(material.E_m) ...
                           '_a_' num2str(geom.a*1000) 'mm_ratio_' rationame ...
                           '.json']);
        json = savejson('',output,filename);
        
      end
    end
  end

