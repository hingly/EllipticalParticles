function steploads= macrostress(steploads, Sigma_p, Eps_int, loads,geom)

% This function computes the macroscopic stress terms given the 
% first macroscopic strain and guesses for the particle stress and 
% interface strain.  



%Define mu for convenience
mu=material.mu_m;

% Calculate MacroStress (eq 4.82, 4.81)
materialterm=2*mu/(1-geom.nu_m*(1+loads.StressRatio_22));
particleterm = -1/(2*mu)*((1-geom.nu_m)*Sigma_p(1) - geom.nu_m*Sigma_p(2));
steploads.MacroStress(1) = materialterm*(steploads.MacroStrain(1) - geom.f*(particleterm + Eps_int(1)));
steploads.MacroStress(2)=loads.StressRatio_22*steploads.MacroStress(1);
steploads.MacroStress(3)=loads.StressRatio_12*steploads.MacroStress(1);

% Calculate remaining element of MacroStrain (eq 4.80)
steploads.MacroStrain(2) = 2*mu*((1-geom.nu_m)*steploads.MacroStress(2) - geom.nu_m*steploads.MacroStress(1)) + geom.f*(-2*mu*((1-geom.nu_m)*Sigma_p(2) - geom.nu_m*Sigma_p(1)) + Eps_int(2));
steploads.MacroStrain(3) = 2*mu*steploads.MacroStress(3) + geom.f*(-2*mu*Sigma_p(3) + Eps_int(3));

		 % Compute matrix stresses (eq 4.68)
steploads.Sigma_m = (steploads.MacroStress - geom.f * Sigma_p)/(1-geom.f);

