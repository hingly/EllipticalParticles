function [soln] = first_guess_soln(loads, material, geom, soln)
  
stress_epsilon = 1e-5;

  % guess for first mode of first timestep of sk is based on size of particle
  soln.sk(1,1)=geom.a/10;

%--------------------------------------
% Guesses FOR FIRST TIMESTEP soln
%======================================


% guess for first mode of first timestep of sk is based on size of particle
  soln.sk(1,1)=geom.a/10;

  tt = 1;
  if loads.SigBar_xy(1) < stress_epsilon
    %Special case where we have to make a different assumption
 
    % Sigma_p has the same shape as the imposed macroscopic stress,
    % sigma_p_22 is scaled by the imposed macroscopic strain
    
    soln.Sigma_p(tt,1) = 0;
    soln.Sigma_p(tt,2) = - loads.DriverStrain(tt)*material.E_m/((1+material.nu_m)*material.nu_m);
    soln.Sigma_p(tt,3) = soln.Sigma_p(tt,2)*loads.StressRatio_12_22;

    % Eps_int_11 is the same as the imposed macroscopic strain
    % Eps_int_22 is scaled by Poisson effect
    % Eps_int_12 is scaled by shape of macroscopic stress 

    soln.Eps_int(tt,1) = loads.DriverStrain(tt);
    soln.Eps_int(tt,2) = - soln.Eps_int(tt,1)*(1-material.nu_m)/material.nu_m;
    soln.Eps_int(tt,3) = soln.Eps_int(tt,2)*loads.StressRatio_12_22;  
    
  else

    % First guess for soln.Sigma_p
    % Sigma_p has the same shape as the imposed macroscopic stress,
    % sigma_p_11 is scaled by the imposed macroscopic strain
  
    soln.Sigma_p(tt,1) = loads.DriverStrain(tt)*material.E_m;
    soln.Sigma_p(tt,2) = soln.Sigma_p(tt,1)*loads.StressRatio_22;
    soln.Sigma_p(tt,3) = soln.Sigma_p(tt,1)*loads.StressRatio_12;

    %First guess for soln.Eps_int
    % Eps_int has the same shape as the imposed macroscopic stress,
    % eps_int_11  is the same as the imposed macroscopic strain

    soln.Eps_int(tt,1) = loads.DriverStrain(tt);
    soln.Eps_int(tt,2) = soln.Eps_int(tt,1)*loads.StressRatio_22;
    soln.Eps_int(tt,3) = soln.Eps_int(tt,1)*loads.StressRatio_12;   
  end
    

