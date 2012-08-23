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
false_stepsintpoints=false(NumSteps,NumPoints);


%-----------------------------------------
% Test Mode I tension unloading (modeI_tu)
%=========================================


%Initialise structure for Mode I tension unloading

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=false_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u1=linspace(0, material.delopen*(1+material.lambda_e)/2, NumSteps1+1);
u1=u1(1:NumSteps1);
u2=linspace(material.delopen*(1+material.lambda_e)/2, material.delopen/4, NumSteps2+1);
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

epsilon2=1e-2;
distances = points_to_lines(xs_loading, ys_loading, linexs_loading, lineys_loading);
plot(distances)
assert(allequal(distances, zeros(size(distances)), epsilon2), ...
       'Incorrect points generated during loading');

% Check for unloading part of curve
lineys_unloading = [0 material.sigmax/2];
linexs_unloading = [0 material.delopen*(1+material.lambda_e)/2];

points_to_lines(xs_unloading, ys_unloading, linexs_unloading, lineys_unloading);
assert(allequal(distances, 0, epsilon), ...
       'Incorrect points generated during unloading');

