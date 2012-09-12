function test_Cohesive_Law_mixedmode_tu


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
  % Test Mixed mode positive shear loading
  %=========================================



  % Populate displacement vector
  u1=linspace(0,material.delopen*(1+material.lambda_e)/2/sqrt(2), NumSteps1+1);
  u1=u1(1:NumSteps1);
  u2=linspace(material.delopen*(1+material.lambda_e)/2/sqrt(2), material.delopen/4/sqrt(2), NumSteps2+1);
  u2=u2(1:NumSteps2);
  u3=linspace(material.delopen/4/sqrt(2), material.delopen*1.1, NumSteps3);
  u=[u1 u2 u3];
  v=u;

  displacement_t=u+i*v;

  cohesive_t = Cohesive_test_common(NumPoints, NumSteps,  displacement_t, ...
                                    material);
  


  
  %---------------------------------------------
  % Test Mixed Mode negative shear loading
  %=============================================


  % Populate displacement vector
  u1=linspace(0, material.delopen*(1+material.lambda_e)/2/sqrt(2), NumSteps1+1);
  u1=u1(1:NumSteps1);
  u2=linspace(material.delopen*(1+material.lambda_e)/2/sqrt(2), material.delopen/4/sqrt(2), NumSteps2+1);
  u2=u2(1:NumSteps2);
  u3=linspace(material.delopen/4/sqrt(2), material.delopen*1.1, NumSteps3);
  u=[u1 u2 u3];
  v=-u;

  displacement_c=u+i*v;

  cohesive_c = Cohesive_test_common(NumPoints, NumSteps,  displacement_c, material);


  
  %-----------------
  % Check results
  %=================
  
  % Check that lambda_max is updating correctly
  assert(lessthanequal(cohesive_t.lambda, cohesive_t.lambda_max, epsilon),...
         'lambda_max is not updating correctly --- positive shear');
  
  assert(lessthanequal(cohesive_c.lambda, cohesive_c.lambda_max, epsilon),...
         'lambda_max is not updating correctly --- negative shear');
  

  % Check that loading flag is being set correctly
  loadingcheck_t=(cohesive_t.lambda_max-cohesive_t.lambda) < epsilon;
  loadingcheck_c=(cohesive_c.lambda_max-cohesive_c.lambda) < epsilon;

  assert(all(cohesive_t.loading==loadingcheck_t), ...
         'Loading flag is not being set correctly --- positive shear');
  assert(all(cohesive_c.loading==loadingcheck_c), ...
         'Loading flag is not being set correctly --- negative shear');


  % Create loading set for mode I
  xs_loading_t1=real(displacement_t(cohesive_t.loading));
  xs_loading_c1=real(displacement_c(cohesive_c.loading));
  ys_loading_t1=real(cohesive_t.traction(cohesive_t.loading))';
  ys_loading_c1=real(cohesive_c.traction(cohesive_c.loading))';
  xs_loading1=[xs_loading_t1 xs_loading_c1];
  ys_loading1=[ys_loading_t1 ys_loading_c1];

  % Create loading set for mode II
  xs_loading_t2=imag(displacement_t(cohesive_t.loading));
  xs_loading_c2=imag(displacement_c(cohesive_c.loading));
  ys_loading_t2=imag(cohesive_t.traction(cohesive_t.loading))';
  ys_loading_c2=imag(cohesive_c.traction(cohesive_c.loading))';
  xs_loading2=[xs_loading_t2 xs_loading_c2];
  ys_loading2=[ys_loading_t2 ys_loading_c2];

  % Check for loading part of curve
  lineys_loading = [0 0 -material.sigmax/sqrt(2) 0 material.sigmax/sqrt(2) 0 0];
  linexs_loading = [min(imag(displacement_c)) -material.delopen/sqrt(2) ...
                    -material.lambda_e*material.delopen/sqrt(2) 0 ...
                    material.lambda_e*material.delopen/sqrt(2) ...
                    material.delopen/sqrt(2) max(imag(displacement_t))];

  epsilon2=material.sigmax/NumSteps;  
  distances = points_to_lines(xs_loading1, ys_loading1, linexs_loading, lineys_loading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during loading --- mode I');

  distances = points_to_lines(xs_loading2, ys_loading2, linexs_loading, lineys_loading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during loading --- mode II');

  % Check for unloading part of curve - mode I
  xs_unloading_t1=real(displacement_t(~cohesive_t.loading));
  ys_unloading_t1=real(cohesive_t.traction(~cohesive_t.loading))';
  xs_unloading_c1=real(displacement_c(~cohesive_c.loading));
  ys_unloading_c1=real(cohesive_c.traction(~cohesive_c.loading))';
  xs_unloading1=[xs_unloading_t1 xs_unloading_c1];
  ys_unloading1=[ys_unloading_t1 ys_unloading_c1];
  
  % Check for unloading part of curve - mode II
  xs_unloading_t2=imag(displacement_t(~cohesive_t.loading));
  ys_unloading_t2=imag(cohesive_t.traction(~cohesive_t.loading))';
  xs_unloading_c2=imag(displacement_c(~cohesive_c.loading));
  ys_unloading_c2=imag(cohesive_c.traction(~cohesive_c.loading))';
  xs_unloading2=[xs_unloading_t2 xs_unloading_c2];
  ys_unloading2=[ys_unloading_t2 ys_unloading_c2];
  
  lineys_unloading = [0 material.sigmax/2/sqrt(2)];
  linexs_unloading = [0 material.delopen*(1+material.lambda_e)/2/sqrt(2)];

  distances = points_to_lines(xs_unloading1, ys_unloading1, linexs_unloading, lineys_unloading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during unloading --- mode I');

  distances = points_to_lines(xs_unloading1, ys_unloading1, linexs_unloading, lineys_unloading);
  assert(allequal(distances, zeros(size(distances)), epsilon2), ...
         'Incorrect points generated during unloading --- mode II');

  
