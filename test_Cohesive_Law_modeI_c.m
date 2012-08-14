function test_Cohesive_Law_modeI_c

epsilon = 1e-5;

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



%--------------------------------------
% Test Mode I compression  (modeI_c)
%======================================


%Initialise structure for Mode I compression 

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=zero_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u=linspace(0,-material.delopen*1.1,NumSteps);
v=linspace(0,0,NumSteps);

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

% Check that lambda is zero
assert(almostequal(cohesive.lambda,0,epsilon), ...
       'lambda should be zero under compression')

% Check that cohesive traction separation law is the expected shape
% for mode I compression
delta_points = [0 -material.lambda_e*material.delopen];
sigma_points = [0 -material.sigmax ];
desired_traction = interp1(delta_points, sigma_points, ...
                           displacement, 'extrap')';

assert(almostequal(cohesive.traction, desired_traction,epsilon),...
       'cohesive traction separation law is not the expected shape for mode I loading');

