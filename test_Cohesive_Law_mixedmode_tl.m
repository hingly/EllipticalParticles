function test_Cohesive_Law_mixedmode_tl


  [material, epsilon, NumPoints] = Cohesive_test_input;

  % Number of steps in the displacement vector
  NumSteps=200;


  %-----------------------------------------
  % Test Mixed mode positive shear loading
  %=========================================

  % Populate displacement vector
  u=linspace(0, material.delopen*1.1, NumSteps);
  v=linspace(0, material.delslide*1.1, NumSteps);

  displacement_t=u+i*v;

  cohesive_t = Cohesive_test_common(NumPoints, NumSteps,  displacement_t, material);


  %---------------------------------------------
  % Test Mixed Mode negative shear loading
  %=============================================


  % Populate displacement vector
  u=linspace(0, material.delopen*1.1, NumSteps);
  v=linspace(0, -material.delslide*1.1, NumSteps);

  displacement_c=u+i*v;

  cohesive_c = Cohesive_test_common(NumPoints, NumSteps,  displacement_c, material);


  
  %-----------------
  % Check results
  %=================
  
  % Check that lambda_max is updating correctly
  assert(almostequal(cohesive_t.lambda, cohesive_t.lambda_max, epsilon),...
         'lambda_max is not updating correctly --- positive shear');
  
  assert(almostequal(cohesive_c.lambda, cohesive_c.lambda_max, epsilon),...
         'lambda_max is not updating correctly --- negative shear');
  
  
  % Create mode I points set
  xs_loading_t1=real(displacement_t(cohesive_t.loading));
  ys_loading_t1=real(cohesive_t.traction(cohesive_t.loading))';
  xs_loading_c1=real(displacement_c(cohesive_c.loading));
  ys_loading_c1=real(cohesive_c.traction(cohesive_c.loading))';
  xs1=[xs_loading_t1 xs_loading_c1];
  ys1=[ys_loading_t1 ys_loading_c1];

  % Create mode II points set
  xs_loading_t2=imag(displacement_t(cohesive_t.loading));
  ys_loading_t2=imag(cohesive_t.traction(cohesive_t.loading))';
  xs_loading_c2=imag(displacement_c(cohesive_c.loading));
  ys_loading_c2=imag(cohesive_c.traction(cohesive_c.loading))';
  xs2=[xs_loading_t2 xs_loading_c2];
  ys2=[ys_loading_t2 ys_loading_c2];
  

  % Check for loading part of curve
  lineys_loading = [0 0 -material.sigmax/sqrt(2) 0 material.sigmax/sqrt(2) 0 0];
  linexs_loading = [min(imag(displacement_c)) -material.delopen/sqrt(2) ...
                    -material.lambda_e*material.delopen/sqrt(2) 0 ...
                    material.lambda_e*material.delopen/sqrt(2) ...
                    material.delopen/sqrt(2) max(imag(displacement_t))];

  epsilon2=material.sigmax/NumSteps;
  distances1 = points_to_lines(xs1, ys1, linexs_loading, lineys_loading);
  assert(allequal(distances1, zeros(size(distances1)), epsilon2), ...
         'Incorrect points generated during loading --- mode I');
  distances2 = points_to_lines(xs2, ys2, linexs_loading, lineys_loading);
  assert(allequal(distances2, zeros(size(distances2)), epsilon2), ...
         'Incorrect points generated during loading --- mode II');




