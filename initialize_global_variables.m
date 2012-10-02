function [loads, macro_var, displacement, cohesive, potential, soln] = ...
    initialize_global_variables(loads, geom, material)

  % This subroutine initializes all the loading, stress and strain arrays, and computes the 
  % imposed macroscopic stress in local rather than principal coordinates.
 
  disp('Initializing global variables...');
  
  
  % constants
  zero_matrix = zeros(1,3);
  zero_timestep_matrix = zeros(loads.timesteps,3);
  zero_timestep_modes=zeros(loads.timesteps, loads.NumModes+1);
  zero_timestep_intpoints=zeros(loads.timesteps,geom.NumPoints);
  zero_intpoints=zeros(1,geom.NumPoints);
  
  
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
  soln.sk=zero_timestep_modes;          
  % Initialise average particle stress matrix
  soln.Sigma_p=zero_timestep_matrix;         
  % Initialise interfacial strain matrix
  soln.Eps_int=zero_timestep_matrix;                  

  
%---------------------------------------------
% Initialize macroscopic variables and arrays
%=============================================  

  macro_var.MacroStrain=zero_timestep_matrix;              % Initialise macroscopic strain matrix
  macro_var.MacroStress=zero_timestep_matrix;              % Initialise macroscopic stress matrix
  macro_var.Sigma_m=zero_timestep_matrix;                  % Initialise Mori-Tanaka matrix stress matrix

  
%---------------------------------------------
% Initialize displacement array
%=============================================  

displacement.farfield=zero_timestep_intpoints;
displacement.farfield_xy=zero_timestep_intpoints;
displacement.coh=zero_timestep_intpoints;
displacement.coh_xy=zero_timestep_intpoints;
displacement.total=zero_timestep_intpoints;
displacement.total_xy=zero_timestep_intpoints;

%---------------------------------------------
% Initialize cohesive array
%=============================================  

cohesive.traction=zero_timestep_intpoints;
cohesive.traction_xy=zero_timestep_intpoints;
cohesive.lambda=zero_timestep_intpoints;
cohesive.lambda_xy=zero_timestep_intpoints;
cohesive.lambda_max=zero_timestep_intpoints;
cohesive.loading=zero_timestep_intpoints;

%---------------------------------------------
% Initialize potential functions
%=============================================  

potential.phi=zero_timestep_intpoints;
potential.phiprime=zero_timestep_intpoints;
potential.psi=zero_timestep_intpoints;
potential.phicoh=zero_timestep_intpoints;
potential.phiprimecoh=zero_timestep_intpoints;
potential.psicoh=zero_timestep_intpoints;




  
  
