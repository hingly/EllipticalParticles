function[material] = calculate_material(material)


%---------------------------------------------------------
% Calculate additional material parameters
%---------------------------------------------------------


% Lame modulus
material.mu_m = material.E_m/(2*(1 + material.nu_m));       
% Lame modulus
material.lambda_m = (material.E_m * material.nu_m)/((1 + material.nu_m)*(1-2*material.nu_m));  


if (material.plstrain==1)
    material.kappa_m = 3 + 4*material.nu_m;
    % plane strain kappa
elseif (material.plstrain==0)
    material.kappa_m = (3 - material.nu_m)/(1 + material.nu_m);
    % plane stress kappa
else
    error('variable plstrain must have a value of 0 or 1')
end

material.delslide = material.cohscale*material.delopen;   
%critical sliding displacement is given by cohesive scaling parameter multiplied with critical opening displacement

material.gint = material.sigmax*material.delopen/2;       
% Cohesive energy is area under curve

