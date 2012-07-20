function [loads,soln,stepload]=initialize_loading(loads, geom)

  % This subroutine initializes all the loading, stress and strain arrays, and computes the 
  % imposed macroscopic stress in local rather than principal coordinates.

  % Edited 4/7/2012 added loads.lambda_max
  
  % constants
  zero_matrix = zeros(1,3);
  zero_timestep_matrix = zeros(loads.timesteps,3);
  zero_timestep_modes=zeros(loads.timesteps, loads.NumModes+1);
  zero_timestep_intpoints=zeros(loads.timesteps,geom.NumPoints+1);
  
  
%---------------------------------------------
% Initialize loading variables and arrays
%=============================================

  loads.MaximumStrain=loads.MinimumStrain*loads.LoadFactor;  % Maximum applied strain


  loads.MacroStrain=zero_timestep_matrix;              % Initialise macroscopic strain matrix
  loads.MacroStress=zero_timestep_matrix;              % Initialise macroscopic stress matrix
  loads.Sigma_m=zero_timestep_matrix;                  % Initialise Mori-Tanaka matrix stress matrix

  % Load stepping occurs in macroscopic strain component epsilon_11 - populate those elements of the macroscopic
  % strain matrix.  (Epsilon_22 and epsilon_12 will be solved for.)

  loads.MacroStrain(:,1)=linspace(loads.MinimumStrain, loads.MaximumStrain, loads.timesteps);


%---------------------------------------------
% Initialize solution variables and arrays
%=============================================


  % Fourier coefficients
  soln.sk=zero_timestep_modes;        
  % Even numbers only from -NumModes to NumModes
  soln.sk(1,1)=geom.a/10;
  % guess for first mode of first timestep of sk is based on size
  % of particle
  
  soln.Sigma_p=zero_timestep_matrix;                  % Initialise average particle stress matrix
  soln.Eps_int=zero_timestep_matrix;                  % Initialise interfacial strain matrix


%---------------------------------------------
% Initialize displacement array
%=============================================  

disp.farfield=zero_timestep_intpoints;
disp.farfield_xy=zero_timestep_intpoints;
disp.coh=zero_timestep_intpoints;
disp.coh_xy=zero_timestep_intpoints;
disp.total=zero_timestep_intpoints;
disp.total_xy=zero_timestep_intpoints;

%---------------------------------------------
% Initialize cohesive array
%=============================================  

coh.traction=zero_timestep_intpoints;
coh.traction_xy=zero_timestep_intpoints;
coh.lambda=zero_timestep_intpoints;
coh.lambda_xy=zero_timestep_intpoints;
coh.lambda_max=zero_timestep_intpoints;
coh.loading=zero_timestep_intpoints;



%---------------------------------------------
% Initialize potential functions
%=============================================  

potential.phi=zero_timestep_intpoints;
potential.phiprime=zero_timestep_intpoints;
potential.psi=zero_timestep_intpoints;
potential.phicoh=zero_timestep_intpoints;
potential.phiprimecoh=zero_timestep_intpoints;
potential.psicoh=zero_timestep_intpoints;


%------------------------------------------------------------------
% Compute imposed maximum macroscopic stress in local coordinates
%==================================================================

  % User inputs imposed macroscopic stress as principal stress with rotation angle

  %Calculate second applied principal stress
  loads.SigmaBar2=loads.SigmaBarRatio*loads.SigmaBar1;

  N1=loads.SigmaBar1;
  N2=loads.SigmaBar2;
  omega=loads.AppliedLoadAngle;


  % Note the imposed macroscopic stress indicates only the "shape" that the
  % stress should have, not the magnitude.   The magnitude is
  % calculated from the macroscopic strain_11 which drives the calculation

  % We convert the imposed macroscopic stress from principal to local coordinates

  %Macroscopic stress vector (local coordinates)
  loads.SigBar_xy=zero_matrix;

  % Convert the imposed principal stresses to local coordinates
  [loads.SigBar_xy(1), loads.SigBar_xy(2), loads.SigBar_xy(3)]=unprincipal(N1,N2,omega);

  
  % Compute the new stress ratios, loads.StressRatio_22 and loads.StressRatio_12 

  if loads.SigBar_xy(1)==0
    %error(['Zero stress in the 11 direction.  The code cant accommodate this right now');
    % Ratio of sigma_12 to sigma_22
    loads.StressRatio_12_22 = loads.SigBar_xy(3)/loads.SigBar_xy(2);
  else
    % Ratio of sigma_22 to sigma_11
    loads.StressRatio_22 = loads.SigBar_xy(2)/loads.SigBar_xy(1);    
    % Ratio of sigma_12 to sigma_11
    loads.StressRatio_12 = loads.SigBar_xy(3)/loads.SigBar_xy(1);
  end
  
  
  
 
  % Guesses FOR FIRST TIMESTEP soln
  tt = 1;
  if loads.SigBar_xy(1)==0
    %Special case where we have to make a different assumption
 
    % Sigma_p has the same shape as the imposed macroscopic stress,
    % sigma_p_22 is scaled by the imposed macroscopic strain
    
    soln.Sigma_p(tt,1) = 0;
    soln.Sigma_p(tt,2) = - loads.MacroStrain(tt,1)*material.E_m/((1+material.nu_m)*material.nu_m);
    soln.Sigma_p(tt,3) = soln.Sigma_p(tt,2)*loads.StressRatio_12_22;

    % Eps_int_11 is the same as the imposed macroscopic strain
    % Eps_int_22 is scaled by Poisson effect
    % Eps_int_12 is scaled by shape of macroscopic stress 

    soln.Eps_int(tt,1) = loads.MacroStrain(tt,1);
    soln.Eps_int(tt,2) = - soln.Eps_int(tt,1)*(1-material.nu_m)/material.nu_m;
    soln.Eps_int(tt,3) = soln.Eps_int(tt,2)*loads.StressRatio_12_22;  
    
  else

    % First guess for soln.Sigma_p
    % Sigma_p has the same shape as the imposed macroscopic stress,
    % sigma_p_11 is scaled by the imposed macroscopic strain
  
    soln.Sigma_p(tt,1) = loads.MacroStrain(tt,1)*material.E_m;
    soln.Sigma_p(tt,2) = soln.Sigma_p(tt,1)*loads.StressRatio_22;
    soln.Sigma_p(tt,3) = soln.Sigma_p(tt,1)*loads.StressRatio_12;

    %First guess for soln.Eps_int
    % Eps_int has the same shape as the imposed macroscopic stress,
    % eps_int_11  is the same as the imposed macroscopic strain

    soln.Eps_int(tt,1) = loads.MacroStrain(tt,1);
    soln.Eps_int(tt,2) = soln.Eps_int(tt,1)*loads.StressRatio_22;
    soln.Eps_int(tt,3) = soln.Eps_int(tt,1)*loads.StressRatio_12;   
  end
    
  % Initialise loading data for timesteps
  stepload.MacroStrain=zero_matrix;
  stepload.MacroStress=zero_matrix;
  stepload.Sigma_m=zero_matrix;
    

  
  