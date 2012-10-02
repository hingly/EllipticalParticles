function test_calculatedisplacement_ellipse

epsilon=1e-10;

material.E_m = 4300;
material.nu_m = 0.35;

% Lame modulus
material.mu_m = material.E_m/(2*(1 + material.nu_m));       
% Bulk modulus
material.kappa_m = 3 + 4*material.nu_m;
    


%--------------------------------------------------
% For an ellipse
%=================================================


error('not finished yet')
