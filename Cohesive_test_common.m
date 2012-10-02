function [cohesive] = Cohesive_test_common(NumPoints, NumSteps,  displacement, material)

% initialise arrays
zero_intpoints = zeros(1,NumPoints);
zero_stepsintpoints = zeros(NumSteps,NumPoints);
false_stepsintpoints = false(NumSteps,NumPoints);

cohesive.lambda = zero_stepsintpoints;
cohesive.lambda_max = zero_stepsintpoints;
cohesive.loading = false_stepsintpoints;
cohesive.traction = zero_stepsintpoints;


for timestep=1:NumSteps
  
  step.displacement.total=displacement(timestep);
  step.cohesive.lambda=cohesive.lambda(timestep,:);
  step.cohesive.lambda_max=cohesive.lambda_max(timestep,:);
  step.cohesive.loading=cohesive.loading(timestep,:);

  % Cohesive law
  step = Cohesive_Law(NumPoints,material,step);

  % Write step quantites to stored quantities
  cohesive.lambda(timestep,:) = step.cohesive.lambda;
  cohesive.traction(timestep,:) = step.cohesive.traction;
  cohesive.lambda_max(timestep,:) = step.cohesive.lambda_max_temp;
  cohesive.loading(timestep,:) = step.cohesive.loading_temp;

  % Prime stored quantities
  if timestep<NumSteps
    cohesive.lambda_max(timestep+1,:) = cohesive.lambda_max(timestep,:);
    cohesive.loading(timestep+1,:) = cohesive.loading(timestep,:);
  end

end


