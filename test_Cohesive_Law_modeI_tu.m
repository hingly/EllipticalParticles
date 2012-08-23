function test_Cohesive_Law_modeI_tu

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

% Number of steps in first loading phase
NumSteps1 = 100;

%Number of steps in unloading phase
NumSteps2 = 50;

%Number of steps in second loading phase
NumSteps3 = 150;

% Number of steps in the displacement vector
NumSteps=NumSteps1+NumSteps2+NumSteps3;


% initialise arrays
zero_intpoints=zeros(1,NumPoints);
zero_stepsintpoints=zeros(NumSteps,NumPoints);



%-----------------------------------------
% Test Mode I tension unloading (modeI_tu)
%=========================================


%Initialise structure for Mode I tension unloading

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=zero_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u1=linspace(0,material.delopen/2, NumSteps1+1);
u1=u1(1:NumSteps1);
u2=linspace(material.delopen/2, material.delopen/4, NumSteps2+1);
u2=u2(1:NumSteps2);
u3=linspace(material.delopen/4, material.delopen*1.1, NumSteps3);
u=[u1 u2 u3];
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


plot(displacement, cohesive.traction,'x-')

% Check that lambda_max is updating correctly
assert(lessthanequal(cohesive.lambda, cohesive.lambda_max),...
       'lambda_max is not updating correctly')

% Check that loading flag is being set correctly
loadingcheck=zeros(NumSteps,1);
for kk=1:NumSteps
  if (cohesive.lambda_max(kk)-cohesive.lambda(kk)) < epsilon
    loadingcheck(kk)=1;
  end
end

assert(allequal(cohesive.loading,loadingcheck,epsilon), ...
       'Loading flag is not being set correctly');


% FIXME : Still need to write this test!!!
% Check that cohesive traction separation law is the expected shape
% for mode I unloading
delta_points = [0 material.lambda_e*material.delopen material.delopen max(displacement)];
sigma_points = [0 material.sigmax 0 0];
desired_traction = interp1(delta_points, sigma_points, displacement)';

assert(almostequal(cohesive.traction, desired_traction,epsilon),...
       'cohesive traction separation law is not the expected shape for mode I unloading');

