function test_Cohesive_Law


% FIXME : consider making these not hard-coded

material.delopen=0.5;
material.delslide=0.5;
material.gint=5;
%corresponds to sigmax=20
material.lambda_e=0.01;

NumPoints=1;
%Only 1 point around the ellipse

NumSteps=200;
% Number of steps in the displacement vector


% initialise arrays
zero_intpoints=zeros(1,NumPoints+1);
zero_stepsintpoints=zeros(NumSteps,NumPoints+1);



%--------------------------------------
% Test Mode I tension loading (modeI_tl)
%======================================


%Initialise structure for Mode I tension loading

modeI_tl.displacement=zero_stepsintpoints;
modeI_tl.cohesive.lambda=zero_stepsintpoints;
modeI_tl.cohesive.lambda_max=zero_stepsintpoints;
modeI_tl.cohesive.loading=zero_stepsintpoints;
modeI_tl.cohesive.traction=zero_stepsintpoints;


% Populate displacement vector
u=linspace(0,material.delopen*1.1,NumSteps);
v=zeros(NumSteps);

for step=1:NumSteps
  modeI_tl.displacement(step,1)=u(step)+i*v(step);
  modeI_tl.displacement(step,2)= modeI_tl.displacement(step,1);
end





for step=1:NumSteps
  
  stepdisp=modeI_tl.displacement(step,:);
  stepcoh.lambda=modeI_tl.cohesive.lambda(step,:);
  stepcoh.lambda_max=modeI_tl.cohesive.lambda_max(step,:);
  stepcoh.loading=modeI_tl.cohesive.loading(step,:);

  
  % Cohesive law
  stepcoh=Cohesive_Law(stepdisp,NumPoints,material,stepcoh);


  % Write step quantites to stored quantities
  modeI_tl.cohesive.lambda(step,:)=stepcoh.lambda;
  modeI_tl.cohesive.traction(step,:)=stepcoh.traction;
  modeI_tl.cohesive.lambda_max(step,:)=stepcoh.lambda_max_temp;
  modeI_tl.cohesive.loading(step,:)=stepcoh.loading_temp;

  % Prime stored quantities
  if step<NumSteps
    modeI_tl.cohesive.lambda_max(step+1,:)=modeI_tl.cohesive.lambda_max(step,:);
    modeI_tl.cohesive.loading(step+1,:)=modeI_tl.cohesive.loading(step,:);
  end

end

% $$$ modeI_tl.cohesive.traction(:,1)
% $$$ modeI_tl.cohesive.lambda_max(:,1)
% $$$ modeI_tl.cohesive.lambda(:,1)
% $$$ modeI_tl.cohesive.loading(:,1)
plot(modeI_tl.displacement(:,1),modeI_tl.cohesive.traction(:,1),'bx-');


