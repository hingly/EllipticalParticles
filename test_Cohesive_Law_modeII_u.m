function test_Cohesive_Law_modeII_u

  [material, epsilon, NumPoints] = Cohesive_test_input;

  % Number of steps in first loading phase
  NumSteps1 = 100;

  %Number of steps in unloading phase
  NumSteps2 = 50;

  %Number of steps in second loading phase
  NumSteps3 = 150;

  % Number of steps in the displacement vector
  NumSteps=NumSteps1+NumSteps2+NumSteps3;

  %--------------------------------------------
  % Test Mode II tension unloading (modeII_tu)
  %============================================

  % Populate displacement vector
  u=linspace(0,0,NumSteps);
  v1=linspace(0,material.delslide*(1+material.lambda_e)/2, NumSteps1+1);
  v1=v1(1:NumSteps1);
  v2=linspace(material.delslide*(1+material.lambda_e)/2, material.delslide/4, NumSteps2+1);
  v2=v2(1:NumSteps2);
  v3=linspace(material.delslide/4, material.delslide*1.1, NumSteps3);
  v=[v1 v2 v3];

  displacement_t=u+i*v;

  cohesive_t = Cohesive_test_common(NumPoints, NumSteps,  displacement_t, material);

  %-----------------------------------------------
  % Test Mode II compressive unloading (modeII_cu)
  %===============================================


  % Populate displacement vector
  u=linspace(0,0,NumSteps);
  v1=linspace(0, -material.delslide/2, NumSteps1+1);
  v1=v1(1:NumSteps1);
  v2=linspace(-material.delslide/2, -material.delslide/4, NumSteps2+1);
  v2=v2(1:NumSteps2);
  v3=linspace(-material.delslide/4, -material.delslide*1.1, NumSteps3);
  v=[v1 v2 v3];

  displacement_c=u+i*v;

  cohesive_c = Cohesive_test_common(NumPoints, NumSteps,  displacement_c, material);

  
  %-----------------
  % Check results
  %=================
  
  % Check that lambda_max is updating correctly
  assert(lessthanequal(cohesive_t.lambda, cohesive_t.lambda_max),...
         'lambda_max is not updating correctly --- tension')

  % Check that lambda_max is updating correctly
  assert(lessthanequal(cohesive_c.lambda, cohesive_c.lambda_max),...
         'lambda_max is not updating correctly --- compression')

  % Check that loading flag is being set correctly
  loadingcheck_t=(cohesive_t.lambda_max-cohesive_t.lambda) < epsilon;
  loadingcheck_c=(cohesive_c.lambda_max-cohesive_c.lambda) < epsilon;

  assert(all(cohesive_t.loading==loadingcheck_t), ...
         'Loading flag is not being set correctly --- tension');
  assert(all(cohesive_c.loading==loadingcheck_c), ...
         'Loading flag is not being set correctly --- compression');


  % Create loading set
  xs_loading_t=imag(displacement_t(cohesive_t.loading));
  xs_loading_c=imag(displacement_c(cohesive_c.loading));
  ys_loading_t=imag(cohesive_t.traction(cohesive_t.loading))';
  ys_loading_c=imag(cohesive_c.traction(cohesive_c.loading))';
  xs_loading=[xs_loading_t xs_loading_c];
  ys_loading=[ys_loading_t ys_loading_c];

  

  % Check for loading part of curve
  lineys_loading = [0 0 -material.sigmax 0 material.sigmax 0 0];
  linexs_loading = [min(imag(displacement_c)) -material.delslide ...
                    -material.lambda_e*material.delslide 0 ...
                    material.lambda_e*material.delslide ...
                    material.delslide max(imag(displacement_t))];

  epsilon2=material.sigmax/NumSteps;
  distances = points_to_lines(xs_loading, ys_loading, linexs_loading, lineys_loading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during loading');

  % Check for unloading part of curve
  xs_unloading_t=imag(displacement_t(~cohesive_t.loading));
  ys_unloading_t=imag(cohesive_t.traction(~cohesive_t.loading))';
  xs_unloading_c=imag(displacement_c(~cohesive_c.loading));
  ys_unloading_c=imag(cohesive_c.traction(~cohesive_c.loading))';
  xs_unloading=[xs_unloading_t xs_unloading_c];
  ys_unloading=[ys_unloading_t ys_unloading_c];
  
  lineys_unloading = [0 material.sigmax/2];
  linexs_unloading = [0 material.delopen*(1+material.lambda_e)/2];

  distances = points_to_lines(xs_unloading, ys_unloading, linexs_unloading, lineys_unloading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during unloading');




