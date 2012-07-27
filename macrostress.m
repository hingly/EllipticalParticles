function [MacroStress, MacroStrain,Sigma_m]= macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material)

% This function computes the macroscopic stress, macroscopic strain 
% and matrix stress terms given the first macroscopic strain and guesses 
% for the particle stress and interface strain.  




%Define mu and nu for convenience
mu=material.mu_m;
nu=material.nu_m;
  if loads.SigBar_xy(1)==0
    % Special case that we have to handle differently
    materialterm22 = -2*mu/nu;
    particleterm22 = -1/(2*mu)*((1-nu)*Sigma_p(1) - nu*Sigma_p(2));
    MacroStress(1)=0;
    MacroStress(2) = materialterm22*(MacroStrain(1) - geom.f*(particleterm22 + Eps_int(1)));
    MacroStress(3) = loads.StressRatio_12_22*MacroStress(1);

  else
    % Calculate MacroStress (eq 4.82, 4.81)
    materialterm=2*mu/(1-nu*(1+loads.StressRatio_22));
    particleterm = -1/(2*mu)*((1-nu)*Sigma_p(1) - nu*Sigma_p(2));

    MacroStress(1) = materialterm*(MacroStrain(1) - geom.f*(particleterm + Eps_int(1)));
    MacroStress(2) = loads.StressRatio_22*MacroStress(1);
    MacroStress(3) = loads.StressRatio_12*MacroStress(1);
  end
  
% Calculate remaining element of MacroStrain (eq 4.80)
MacroStrain(2) = 2*mu*((1-nu)*MacroStress(2) - nu*MacroStress(1)) + geom.f*(-2*mu*((1-nu)*Sigma_p(2) - nu*Sigma_p(1)) + Eps_int(2));
MacroStrain(3) = 2*mu*MacroStress(3) + geom.f*(-2*mu*Sigma_p(3) + Eps_int(3));

% Compute matrix stresses (eq 4.68)
Sigma_m = (MacroStress - geom.f * Sigma_p)/(1-geom.f);
