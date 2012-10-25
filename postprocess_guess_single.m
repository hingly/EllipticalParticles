function postprocess_guess_single


c1list = [50];
c2list = [100];
strainlist = [0.001 0.002 0.005 0.01];

% loadcase = 1 for equibiaxial circle
% loadcase = 2 for uniaxial circle
% loadcase = 3 for uniaxial ellipse
% loadcase = 4 for uniaxial circle with more modes

loadcase = 1;

ii = 75;
strain = 0.001;  
c1 = 50;
c2 = 100;
% Determine which filename to open

if loadcase == 1
  filename = strcat(['Guess/equibiaxial/guess_' num2str(ii) '_strain_' ...
                     num2str(strain*1000) '_c1_' num2str(c1) ...
                     '_c2_' num2str(c2) '.json']);
  outputname = strcat(['Guess/equibiaxial/guess_' num2str(ii) '_strain_' ...
                      num2str(strain*1000) '_c1_' num2str(c1) ...
                      '_c2_' num2str(c2) '_postprocess.json']);
  structname = 'circle_equi';
elseif loadcase == 2
  filename = strcat(['Guess/uniaxial/guess_' num2str(ii) '_strain_' ...
                     num2str(strain*1000) '_c1_' num2str(c1) ...
                     '_c2_' num2str(c2) '.json']);
  outputname = strcat(['Guess/uniaxial/guess_' num2str(ii) '_strain_' ...
                      num2str(strain*1000) '_c1_' num2str(c1) ...
                      '_c2_' num2str(c2) '_postprocess.json']);
  structname = 'circle_uni';
elseif loadcase == 3
  filename = strcat(['Guess/ellipse/uniaxial/guess_' num2str(ii) '_strain_' ...
                     num2str(strain*1000) '_c1_' num2str(c1) ...
                     '_c2_' num2str(c2) '_ar_' ...
                     num2str(aspectratio) '.json']);
  outputname = strcat(['Guess/ellipse/uniaxial/guess_' num2str(ii) '_strain_' ...
                      num2str(strain*1000) '_c1_' num2str(c1) ...
                      '_c2_' num2str(c2) '_ar_' ...
                      num2str(aspectratio) '_postprocess.json']);
  structname = 'ellipse_uni';
elseif loadcase == 4
  filename = strcat(['Guess/uniaxial/modes/guess_' num2str(ii) '_strain_' ...
                     num2str(strain*1000) '_c1_' num2str(c1) ...
                     '_c2_' num2str(c2) '.json']);
  outputname = strcat(['Guess/uniaxial/modes/guess_' num2str(ii) '_strain_' ...
                      num2str(strain*1000) '_c1_' num2str(c1) ...
                      '_c2_' num2str(c2) '_postprocess.json']);
  structname = 'circle_uni_modes';
end

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


