function postprocess_jay1

epsilon = 1e-5;
c1list = [50];
c2list = [100];
ratiolist = [0.5]; 
anglelist = [0]*pi/180;
strainlist = [linspace(0.018, 0.0228, 13)];
NumGuesses = 10;

for c1 = c1list
  for c2 = c2list
    for angle = anglelist       
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
            
            disp(['Strain is ' num2str(strain) ' guess ' num2str(ii)]);

            filename = strcat(['Jay/jayrun_' num2str(ii) '_strain_' ...
                               num2str(strain*10000) '_c1_' num2str(c1) ...
                               '_c2_' num2str(c2) '_ratio_' rationame ...
                               '_angle_' num2str(angle*180/pi) '_.json']);
            outputname = strcat(['Jay/jayrun_' num2str(ii) '_strain_' ...
                                num2str(strain*10000) '_c1_' num2str(c1) ...
                                '_c2_' num2str(c2) '_ratio_' rationame ...
                                '_angle_' num2str(angle*180/pi) '_postprocess.json']);
            
            
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
end

