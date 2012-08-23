function test_Cohesive_Law_modeII_l

  [material, epsilon, NumPoints] = Cohesive_test_input;

  % Number of steps in the displacement vector
  NumSteps=200;

  %-----------------------------------------
  % Test Mode II tension loading (modeII_tl)
  %=========================================


  % Populate displacement vector
  u=linspace(0,0,NumSteps);
  v=linspace(0, material.delslide*1.1,NumSteps);

  displacement_t=u+i*v;

  cohesive_t = Cohesive_test_common(NumPoints, NumSteps,  displacement_t, material);

  %---------------------------------------------
  % Test Mode II compressive loading (modeII_cl)
  %=============================================


  % Populate displacement vector
  u=linspace(0,0,NumSteps);
  v=linspace(0, -material.delslide*1.1,NumSteps);

  displacement_c=u+i*v;

  cohesive_c = Cohesive_test_common(NumPoints, NumSteps,  displacement_c, material);

  
  %-----------------
  % Check results
  %=================
  
  % Check that lambda_max is updating correctly
  assert(almostequal(cohesive_t.lambda, cohesive_t.lambda_max, epsilon),...
         'lambda_max is not updating correctly --- tension');
 
  assert(almostequal(cohesive_c.lambda, cohesive_c.lambda_max, epsilon),...
         'lambda_max is not updating correctly --- compression');
  
  % Create points set
  xs_loading_t=imag(displacement_t(cohesive_t.loading));
  ys_loading_t=imag(cohesive_t.traction(cohesive_t.loading))';
  xs_loading_c=imag(displacement_c(cohesive_c.loading));
  ys_loading_c=imag(cohesive_c.traction(cohesive_c.loading))';
  xs=[xs_loading_t xs_loading_c];
  ys=[ys_loading_t ys_loading_c];

  

  % Check for loading part of curve
  lineys_loading = [0 0 -material.sigmax 0 material.sigmax 0 0];
  linexs_loading = [min(imag(displacement_c)) -material.delslide ...
                    -material.lambda_e*material.delslide 0 ...
                    material.lambda_e*material.delslide ...
                    material.delslide max(imag(displacement_t))];

  epsilon2=material.sigmax/NumSteps;
  distances = points_to_lines(xs, ys, linexs_loading, lineys_loading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during loading');


