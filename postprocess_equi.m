function postprocess_equi


c1list = [100];
c2list = [100 200 500];
flist = [0.1 0.2 0.3 0.4 0.5]; 
strainlist = [linspace(0.0002, 0.005, 11)];
NumGuesses = 10;

for c1 = c1list
  for c2 = c2list
    for f = flist      
      
      for strain = strainlist
        for ii = 1:NumGuesses      
          
          
          disp(['Strain is ' num2str(strain) ' guess ' num2str(ii)]);
          
          
          
          % Determine which filename to open
          filename = strcat(['Equibiaxial/equirun_' num2str(ii) '_strain_' ...
                             num2str(strain*10000) '_c1_' num2str(c1) ...
                             '_c2_' num2str(c2) '_f_' num2str(f) '_.json']);
          

          outputname = strcat(['Equibiaxial/equirun_' num2str(ii) '_strain_' ...
                              num2str(strain*10000) '_c1_' num2str(c1) ...
                              '_c2_' num2str(c2) '_f_' num2str(f) ...
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
  end
end




