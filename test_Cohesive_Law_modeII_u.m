function test_Cohesive_Law_modeII_u

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



%--------------------------------------------
% Test Mode II tension unloading (modeII_tu)
%============================================


%Initialise structure for Mode I tension unloading

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=zero_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u=linspace(0,0,NumSteps);
v1=linspace(0,material.delslide/2, NumSteps1+1);
v1=v1(1:NumSteps1);
v2=linspace(material.delslide/2, material.delslide/4, NumSteps2+1);
v2=v2(1:NumSteps2);
v3=linspace(material.delslide/4, material.delslide*1.1, NumSteps3);
v=[v1 v2 v3];

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

% FIXME : Don't know how to write this test

% % Check that cohesive traction separation law is the expected shape
% % for mode II loading
% delta_points = [0 material.lambda_e*material.delslide material.delslide max(imag(displacement))];
% sigma_points = [0 material.sigmax 0 0];
% desired_traction1 = interp1(delta_points, sigma_points, imag(displacement))';

% assert(almostequal(imag(cohesive.traction), desired_traction1,epsilon),...
%        'cohesive traction separation law is not the expected shape for mode II loading');


%-----------------------------------------------
% Test Mode II compressive unloading (modeII_cu)
%===============================================


%Initialise structure for Mode I tension loading

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=zero_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u=linspace(0,0,NumSteps);
v1=linspace(0, -material.delslide/2, NumSteps1+1);
v1=v1(1:NumSteps1);
v2=linspace(-material.delslide/2, -material.delslide/4, NumSteps2+1);
v2=v2(1:NumSteps2);
v3=linspace(-material.delslide/4, -material.delslide*1.1, NumSteps3);
v=[v1 v2 v3];

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

% % Check that cohesive traction separation law is the expected shape
% % for mode II loading
% delta_points = [min(imag(displacement)) -material.delslide ...
%                 -material.lambda_e*material.delslide 0];
% sigma_points = [0 0 -material.sigmax 0];
% desired_traction2 = interp1(delta_points, sigma_points, imag(displacement))';

% assert(almostequal(imag(cohesive.traction), desired_traction2,epsilon),...
%        'cohesive traction separation law is not the expected shape for mode II loading');

% assert(almostequal(desired_traction1, -desired_traction2, epsilon), ...
%        'traction behaviour is not antisymmetric');

error('still need to write test');
