function postprocess_jay4

epsilon = 1e-5;
strainlist = [linspace(0.0004, 0.04, 100)];
NumGuesses = 10;

ratiolist = [0]; 



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

      material.E_m = 4300;
      geom.a = 90;

      disp(['Strain is ' num2str(strain) ' guess ' num2str(ii)]);

      filename = strcat(['Jay/compare/jayrun_' num2str(ii) '_strain_' ...
                         num2str(strain*10000) '_E_' num2str(material.E_m) ...
                         '_a_' num2str(geom.a) 'mm_lambda_e_big_ratio_' rationame ...
                         '.json']);
      outputname = strcat(['Jay/compare/jayrun_' num2str(ii) '_strain_' ...
                          num2str(strain*10000) '_E_' num2str(material.E_m) ...
                          '_a_' num2str(geom.a) 'mm_lambda_e_big_ratio_' rationame ...
                          '_postprocess.json']);
      
      
      % Read data from json file
      data = loadjson(filename);
      
      loads = data.loads;
      material = data.material;
      geom = data.geom;
      guess_test = data.guess_test;
      soln = data.soln;
      
      if soln.exitflag == 1
        
        % initialise necessary variables
        loads.DriverStrain = [strain];
        step = initialize_step_variables(loads, geom);
        tt = 1;
        cohesive.loading = true(loads.timesteps,geom.NumPoints);
        cohesive.lambda_max = zeros(loads.timesteps,geom.NumPoints);
        
        % Calculate final values based on converged sk, sigma_p and eps_int
        step = final(soln, loads, material, geom, step, tt, ...
                     cohesive);
        
        % TODO need to write to global structure
        
      else
        step = initialize_step_variables(loads, geom);
      end

      data.step = step;         
      
      json = savejson('', data, outputname);
      
    end
  end
end

