function test_Cohesive_Law_modeII_l

epsilon = 1e-5;

% FIXME : consider making these not hard-coded

material.delopen=0.5;
material.delslide=0.5;
material.gint=5;
%corresponds to sigmax=20
material.lambda_e=0.01;

material.sigmax=2*material.gint/material.delopen;
 

NumPoints=1;
%Only 1 point around the ellipse

NumSteps=200;
% Number of steps in the displacement vector


% initialise arrays
zero_intpoints=zeros(1,NumPoints);
zero_stepsintpoints=zeros(NumSteps,NumPoints);



%-----------------------------------------
% Test Mode II tension loading (modeII_tl)
%=========================================


%Initialise structure for Mode I tension loading

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=zero_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u=linspace(0,0,NumSteps);
v=linspace(0, material.delslide*1.1,NumSteps);

displacement=u+i*v;


for step=1:NumSteps
  
  stepdisp=displacement(step);
  stepcoh.lambda=cohesive.lambda(step,:);
  stepcoh.lambda_max=cohesive.lambda_max(step,:);
  stepcoh.loading=cohesive.loading(step,:);

  
  % Cohesive law
  stepcoh=Cohesive_Law(stepdisp,NumPoints,material,stepcoh);


  % Write step quantites to stored quantities
  cohesive.lambda(step,:)=stepcoh.lambda;
  cohesive.traction(step,:)=stepcoh.traction;
  cohesive.lambda_max(step,:)=stepcoh.lambda_max_temp;
  cohesive.loading(step,:)=stepcoh.loading_temp;

  % Prime stored quantities
  if step<NumSteps
    cohesive.lambda_max(step+1,:)=cohesive.lambda_max(step,:);
    cohesive.loading(step+1,:)=cohesive.loading(step,:);
  end

end

% Check that lambda_max is updating correctly
assert(almostequal(cohesive.lambda, cohesive.lambda_max, epsilon),...
       'lambda_max is not updating correctly')

% Check that cohesive traction separation law is the expected shape
% for mode II loading
delta_points = [0 material.lambda_e*material.delslide material.delslide max(imag(displacement))];
sigma_points = [0 material.sigmax 0 0];
desired_traction = interp1(delta_points, sigma_points, imag(displacement))';

assert(almostequal(imag(cohesive.traction), desired_traction,epsilon),...
       'cohesive traction separation law is not the expected shape for mode II loading');


%---------------------------------------------
% Test Mode II compressive loading (modeII_cl)
%=============================================


%Initialise structure for Mode I tension loading

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=zero_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u=linspace(0,0,NumSteps);
v=linspace(0, -material.delslide*1.1,NumSteps);

displacement=u+i*v;


for step=1:NumSteps
  
  stepdisp=displacement(step);
  stepcoh.lambda=cohesive.lambda(step,:);
  stepcoh.lambda_max=cohesive.lambda_max(step,:);
  stepcoh.loading=cohesive.loading(step,:);

  
  % Cohesive law
  stepcoh=Cohesive_Law(stepdisp,NumPoints,material,stepcoh);


  % Write step quantites to stored quantities
  cohesive.lambda(step,:)=stepcoh.lambda;
  cohesive.traction(step,:)=stepcoh.traction;
  cohesive.lambda_max(step,:)=stepcoh.lambda_max_temp;
  cohesive.loading(step,:)=stepcoh.loading_temp;

  % Prime stored quantities
  if step<NumSteps
    cohesive.lambda_max(step+1,:)=cohesive.lambda_max(step,:);
    cohesive.loading(step+1,:)=cohesive.loading(step,:);
  end

end

% Check that lambda_max is updating correctly
assert(almostequal(cohesive.lambda, cohesive.lambda_max, epsilon),...
       'lambda_max is not updating correctly')

% Check that cohesive traction separation law is the expected shape
% for mode II loading
delta_points = [min(imag(displacement)) -material.delslide ...
                -material.lambda_e*material.delslide 0];
sigma_points = [0 0 -material.sigmax 0];
desired_traction = interp1(delta_points, sigma_points, imag(displacement))';

assert(almostequal(imag(cohesive.traction), desired_traction,epsilon),...
       'cohesive traction separation law is not the expected shape for mode II loading');


