function test_Cohesive_Law_modeI_tl

  [material, epsilon, NumPoints] = Cohesive_test_input;

  % Number of steps in the displacement vector
  NumSteps=200;

  %--------------------------------------
  % Test Mode I tension loading (modeI_tl)
  %======================================

  % Populate displacement vector
  u=linspace(0,material.delopen*1.1,NumSteps);
  v=linspace(0,0,NumSteps);

  displacement=u+i*v;
  
  cohesive = Cohesive_test_common(NumPoints, NumSteps,  displacement, material);

  % Check that lambda_max is updating correctly
  assert(almostequal(cohesive.lambda, cohesive.lambda_max, epsilon),...
         'lambda_max is not updating correctly')

  % Create loading set
  xs_loading=real(displacement(cohesive.loading));
  ys_loading=real(cohesive.traction(cohesive.loading));


  % Check for loading part of curve
  lineys_loading = [0 material.sigmax 0 0];
  linexs_loading = [0 material.lambda_e*material.delopen ...
                    material.delopen max(real(displacement))];

  epsilon2=material.sigmax/NumSteps;
  distances = points_to_lines(xs_loading, ys_loading, linexs_loading, lineys_loading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during loading');
  
  
  
