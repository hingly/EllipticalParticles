function postprocess_guess


epsilon = 1e-5;
plotflag = true;

c1list = [50];
c2list = [100];
strainlist = [0.001 0.002 0.005 0.01];

% loadcase = 1 for equibiaxial circle
% loadcase = 2 for uniaxial circle
% loadcase = 3 for uniaxial ellipse

for loadcase = 1:3
  if loadcase == 1
    Numfiles = 530;
    aspectlist = [1];
  elseif loadcase == 2
    Numfiles = 217;
    aspectlist = [1];
  elseif loadcase == 3
    Numfiles = 32;
    aspectlist = [2 5];
  end
  
  for ii = 1:Numfiles
    for strain = strainlist
      for c1 = c1list
        for c2 = c2list
          for aspectratio = aspectlist
            
            
            % Determine which filename to open
            
            if loadcase == 1
              filename = strcat(['Guess/equibiaxial/guess_' num2str(ii) '_strain_' ...
                                 num2str(strain*1000) '_c1_' num2str(c1) ...
                                 '_c2_' num2str(c2) '.json']);
              structname = 'circle_equi';
            elseif loadcase == 2
              filename = strcat(['Guess/uniaxial/guess_' num2str(ii) '_strain_' ...
                                 num2str(strain*1000) '_c1_' num2str(c1) ...
                                 '_c2_' num2str(c2) '.json']);
              structname = 'circle_uni';
            elseif loadcase == 3
              filename = strcat(['Guess/ellipse/uniaxial/guess_' num2str(ii) '_strain_' ...
                                 num2str(strain*1000) '_c1_' num2str(c1) ...
                                 '_c2_' num2str(c2) '_ar_' ...
                                 num2str(aspectratio) '.json']);
              structname = 'ellipse_uni';
            end
          
            % Read data from json file
            data = loadjson(filename);
            
            loads = data.loads;
            material = data.material;
            geom = data.geom;
            guess_test = data.guess_test;
            soln = data.soln;
            
            if ii == 1
              % initialise output structure
              structname
              pause
              
            end
            
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
            
              
            else
              step = initialize_step_variables(loads, geom);
              break
            end

                     

            
            
            
          end
        end
      end
    end
  end
end


