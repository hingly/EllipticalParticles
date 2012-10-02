function [step] = initialize_step_variables(loads, geom, tt)

% This subroutine initializes step variables before beginning a loadstep.
  
  % constants
  zero_matrix = zeros(1,3);
  zero_intpoints=zeros(1,geom.NumPoints);
    
  % Initialise loading data for timesteps
  step.macro_var.MacroStrain=zero_matrix;
  step.macro_var.MacroStress=zero_matrix;
  step.macro_var.Sigma_m=zero_matrix;
  step.cohesive.lambda_max=zero_intpoints;
  step.cohesive.loading=zero_intpoints;

  % Write DriverStrain over to step epsilon_11
  step.macro_var.MacroStrain(1)=loads.DriverStrain(tt);

  
