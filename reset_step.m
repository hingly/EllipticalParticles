function step = reset_step(step, loads, tt, cohesive)

% Reset step structure to contain nans everywhere, except
% initialise step.macro_var.MacroStrain(1) and
% step.cohesive.lambda_max, step.cohesive.loading

% Set all values in structure step to NaN
step = set_recursive(step, nan);

% Write DriverStrain over to step epsilon_11
step.macro_var.MacroStrain(1)=loads.DriverStrain(tt);

if tt > 1
  % Set cohesive loading parameters to last converged
  step.cohesive.lambda_max = cohesive.lambda_max(tt-1,:);
  step.cohesive.loading = cohesive.loading(tt-1,:);
else
  assert(tt == 1, 'Something weird happening');
  % First timestep --> lambda_max is zero and loading is true
  step.cohesive.lambda_max(:) = 0;
  step.cohesive.loading(:) = true;
end
