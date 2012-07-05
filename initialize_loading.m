function [loads,soln]=initialize_loading(loads, geom)

  % This subroutine initializes all the loading, stress and strain arrays, and computes the 
  % imposed macroscopic stress in local rather than principal coordinates.

  % Edited 4/7/2012 added loads.lambda_max
  
  
%---------------------------------------------
% Initialize loading variables and arrays
%=============================================

  loads.MaximumStrain=loads.MinimumStrain*loads.LoadFactor;  % Maximum applied strain


  loads.MacroStrain=zeros(loads.timesteps,3);              % Initialise macroscopic strain matrix
  loads.MacroStress=zeros(loads.timesteps,3);              % Initialise macroscopic stress matrix
  loads.Sigma_m=zeros(loads.timesteps,3);                  % Initialise Mori-Tanaka matrix stress matrix

  % Load stepping occurs in macroscopic strain component epsilon_11 - populate those elements of the macroscopic
  % strain matrix.  (Epsilon_22 and epsilon_12 will be solved for.)

  loads.MacroStrain(:,1)=linspace(loads.MinimumStrain, loads.MaximumStrain, loads.timesteps);


%---------------------------------------------
% Initialize solution variables and arrays
%=============================================


  % Fourier coefficients
  soln.sk=zeros(loads.timesteps, loads.NumModes+1);        % Even numbers only from -NumModes to NumModes
  for kk=1:timesteps                                       % FIXME *** this is a stupid guess!!!***
    soln.sk(kk,1)=geom.a/10;
  end

  soln.Sigma_p=zeros(loads.timesteps,3);                  % Initialise average particle stress matrix
  soln.Eps_int=zeros(loads.timesteps,3);                  % Initialise interfacial strain matrix

%---------------------------------------------
% Initialize cohesive damage array
%=============================================  
  
loads.lambda_max=zeros(loads.timesteps,geom.NumPoints+1);          % Maximum value of lambda reached at each integration point
  

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
  loads.SigBar_xy=zeros(1,3);

  % Convert the imposed principal stresses to local coordinates
  [loads.SigBar_xy(1), loads.SigBar_xy(2), loads.SigBar_xy(3)]=unprincipal(N1,N2,omega);

  
  % Compute the new stress ratios, loads.StressRatio_22 and loads.StressRatio_12 

  if loads.SigBar_xy(1)==0
    error(['Zero stress in the 11 direction.  The code cant accommodate ' ...
           ']this right now');
  else
    % Ratio of sigma_22 to sigma_11
    loads.StressRatio_22 = loads.SigBar_xy(2)/loads.SigBar_xy(1);    
    % Ratio of sigma_12 to sigma_11
    loads.StressRatio_12 = loads.SigBar_xy(3)/loads.SigBar_xy(1);
  end
  
  
  
  % Guesses FOR FIRST TIMESTEP soln
  tt = 1;
  soln.Sigma_p(tt,1) = loads.MacroStrain(tt,1)*material.E_m;
  soln.Sigma_p(tt,2) = soln.Sigma_p(tt,1)*loads.StressRatio_22;
  soln.Sigma_p(tt,3) = soln.Sigma_p(tt,1)*loads.StressRatio_12;

  %First guess for soln.Eps_int
  % Eps_int has the same shape as the imposed macroscopic stress,
  % eps_int_11  is the same as the imposed macroscopic strain

  soln.Eps_int(tt,1) = loads.MacroStrain(tt,1);
  soln.Eps_int(tt,2) = soln.Eps_int(tt,1)*loads.StressRatio_22;
  soln.Eps_int(tt,3) = soln.Eps_int(tt,1)*loads.StressRatio_12;   
