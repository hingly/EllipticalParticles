function [loads, macro_var, displacement, cohesive, potential, percentage, soln] = ...
    initialize_global_variables(loads, geom, material)

  % This subroutine initializes all the loading, stress and strain arrays, and computes the 
  % imposed macroscopic stress in local rather than principal coordinates.
 
  %disp('Initializing global variables...');
  
  
  % constants
  nan_matrix = nan(1,3);
  nan_timestep_matrix = nan(loads.timesteps,3);
  nan_timestep_2vector = nan(loads.timesteps,2);
  nan_timestep_modes=nan(loads.timesteps, loads.NumModes+1);
  nan_timestep_intpoints=nan(loads.timesteps,geom.NumPoints);
  nan_intpoints=nan(1,geom.NumPoints);
  false_timestep_intpoints=false(loads.timesteps,geom.NumPoints);
  
  
%---------------------------------------------
% Initialize loading variables and arrays
%=============================================

  loads.MaximumStrain=loads.MinimumStrain*loads.LoadFactor;  % Maximum applied strain

  % Load stepping occurs in macroscopic strain component epsilon_11
  % --> create loads.DriverStrain which will map to epsilon_11
  loads.DriverStrain=linspace(loads.MinimumStrain, loads.MaximumStrain, loads.timesteps);
  
  
%---------------------------------------------
% Initialize solution variables and arrays
%=============================================

  % Fourier coefficients --- Even numbers only from -NumModes to NumModes
  soln.sk = nan_timestep_modes;          
  % Initialise average particle stress matrix
  soln.Sigma_p = nan_timestep_matrix;         
  % Initialise interfacial strain matrix
  soln.Eps_int = nan_timestep_matrix;     
  % Initialise exit flags
  soln.exitflag = nan(1,loads.timesteps);

  
%---------------------------------------------
% Initialize macroscopic variables and arrays
%=============================================  

  macro_var.MacroStrain=nan_timestep_matrix;              % Initialise macroscopic strain matrix
  macro_var.MacroStress=nan_timestep_matrix;              % Initialise macroscopic stress matrix
  macro_var.Sigma_m=nan_timestep_matrix;                  % Initialise Mori-Tanaka matrix stress matrix

  
%---------------------------------------------
% Initialize displacement array
%=============================================  

displacement.farfield=nan_timestep_intpoints;
displacement.farfield_xy=nan_timestep_intpoints;
displacement.coh=nan_timestep_intpoints;
displacement.coh_xy=nan_timestep_intpoints;
displacement.total=nan_timestep_intpoints;
displacement.total_xy=nan_timestep_intpoints;

%---------------------------------------------
% Initialize cohesive array
%=============================================  

cohesive.traction=nan_timestep_intpoints;
cohesive.traction_xy=nan_timestep_intpoints;
cohesive.lambda=nan_timestep_intpoints;
cohesive.lambda_xy=nan_timestep_intpoints;
cohesive.lambda_max=nan_timestep_intpoints;

cohesive.loading=false_timestep_intpoints;


%---------------------------------------------
% Initialize potential functions
%=============================================  

potential.phi=nan_timestep_intpoints;
potential.phiprime=nan_timestep_intpoints;
potential.psi=nan_timestep_intpoints;
potential.phicoh=nan_timestep_intpoints;
potential.phiprimecoh=nan_timestep_intpoints;
potential.psicoh=nan_timestep_intpoints;


%---------------------------------------------
% Initialize damage percentages
%=============================================  

percentage.undamaged = nan_timestep_2vector;
percentage.damaged = nan_timestep_2vector;
percentage.failed = nan_timestep_2vector;
percentage.unloading = nan_timestep_2vector;
percentage.compression = nan_timestep_2vector;



  
  
