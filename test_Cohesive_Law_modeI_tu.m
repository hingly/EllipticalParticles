function test_Cohesive_Law_modeI_tu

  [material, epsilon, NumPoints] = Cohesive_test_input;

  % Number of steps in first loading phase
  NumSteps1 = 100;
  %Number of steps in unloading phase
  NumSteps2 = 50;
  %Number of steps in second loading phase
  NumSteps3 = 150;
  % Number of steps in the displacement vector
  NumSteps=NumSteps1+NumSteps2+NumSteps3;


  %-----------------------------------------
  % Test Mode I tension unloading (modeI_tu)
  %=========================================

  % Populate displacement vector
  u1=linspace(0, material.delopen*(1+material.lambda_e)/2, NumSteps1+1);
  u1=u1(1:NumSteps1);
  u2=linspace(material.delopen*(1+material.lambda_e)/2, material.delopen/4, NumSteps2+1);
  u2=u2(1:NumSteps2);
  u3=linspace(material.delopen/4, material.delopen*1.1, NumSteps3);
  u=[u1 u2 u3];
  v=linspace(0,0,NumSteps);

  displacement=u+i*v;

  cohesive = Cohesive_test_common(NumPoints, NumSteps,  displacement, material);

  % Check that lambda_max is updating correctly
  assert(lessthanequal(cohesive.lambda, cohesive.lambda_max),...
         'lambda_max is not updating correctly')

  % Check that loading flag is being set correctly
  loadingcheck=(cohesive.lambda_max-cohesive.lambda) < epsilon;

  assert(all(cohesive.loading==loadingcheck), ...
         'Loading flag is not being set correctly');

  % Create loading set
  xs_loading=real(displacement(cohesive.loading));
  xs_unloading=real(displacement(~cohesive.loading));
  ys_loading=real(cohesive.traction(cohesive.loading));
  ys_unloading=real(cohesive.traction(~cohesive.loading));


  % Check for loading part of curve
  lineys_loading = [0 material.sigmax 0 0];
  linexs_loading = [0 material.lambda_e*material.delopen ...
                    material.delopen max(real(displacement))];

  epsilon2=material.sigmax/NumSteps;
  distances = points_to_lines(xs_loading, ys_loading, linexs_loading, lineys_loading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during loading');

  % Check for unloading part of curve
  lineys_unloading = [0 material.sigmax/2];
  linexs_unloading = [0 material.delopen*(1+material.lambda_e)/2];

  distances = points_to_lines(xs_unloading, ys_unloading, linexs_unloading, lineys_unloading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during unloading');

