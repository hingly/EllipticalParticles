function [step] = initialize_step_variables(loads, geom, tt)

% This subroutine initializes step variables before beginning a loadstep.
  
  % constants
  nan_matrix = nan(1, 3);
  nan_intpoints = nan(1, geom.NumPoints);
  false_intpoints = false(1, geom.NumPoints);
    
  % Initialise loading data for timesteps
  step.macro_var.MacroStrain = nan_matrix;
  step.macro_var.MacroStress = nan_matrix;
  step.macro_var.Sigma_m = nan_matrix;

  % Initialise cohesive structure  
  step.cohesive.lambda_max = nan_intpoints;
  step.cohesive.traction_xy = nan_intpoints;
  step.cohesive.traction = nan_intpoints;
  step.cohesive.lambda = nan_intpoints;
  step.cohesive.lambda_xy = nan_intpoints;
  step.cohesive.lambda_max_temp = nan_intpoints;

  step.cohesive.loading = false_intpoints;
  step.cohesive.loading_temp = false_intpoints;
    
  % Initialise displacement structure  
  step.displacement.farfield = nan_intpoints;
  step.displacement.farfield_xy = nan_intpoints;
  step.displacement.coh = nan_intpoints;
  step.displacement.coh_xy = nan_intpoints;
  step.displacement.total = nan_intpoints;
  step.displacement.total_xy = nan_intpoints;
  
 
  % Initialise potential structure
  step.potential.phi = nan_intpoints;
  step.potential.phiprime = nan_intpoints;
  step.potential.psi = nan_intpoints;
  step.potential.phicoh = nan_intpoints;
  step.potential.phiprimecoh = nan_intpoints;
  step.potential.psicoh = nan_intpoints;

  
  
  
  
  


  
