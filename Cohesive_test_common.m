function [cohesive] = Cohesive_test_common(NumPoints, NumSteps,  displacement, material)

% initialise arrays
zero_intpoints=zeros(1,NumPoints);
zero_stepsintpoints=zeros(NumSteps,NumPoints);
false_stepsintpoints=false(NumSteps,NumPoints);

cohesive.lambda=zero_stepsintpoints;
cohesive.lambda_max=zero_stepsintpoints;
cohesive.loading=false_stepsintpoints;
cohesive.traction=zero_stepsintpoints;


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


