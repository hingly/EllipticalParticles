function [loads] = calculate_imposed_stress(loads)



  % constants
  zero_matrix = zeros(1,3);

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

  stress_epsilon=1e-5;
  
  % Compute the new stress ratios, loads.StressRatio_22 and loads.StressRatio_12 

  if loads.SigBar_xy(1) < stress_epsilon
    % Ratio of sigma_12 to sigma_22
    loads.StressRatio_12_22 = loads.SigBar_xy(3)/loads.SigBar_xy(2);
  else
    % Ratio of sigma_22 to sigma_11
    loads.StressRatio_22 = loads.SigBar_xy(2)/loads.SigBar_xy(1);    
    % Ratio of sigma_12 to sigma_11
    loads.StressRatio_12 = loads.SigBar_xy(3)/loads.SigBar_xy(1);
  end
  
  
  