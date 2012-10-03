function test_farfieldpotential_circle 

% Test the far-field potential functions for a circle.

%---------------------------------
% Input data
%=================================  

epsilon = 1e-10;

% Input geometric data
geom.a = 10;
geom.b = 10;
geom.NumPoints = 20;

% Calculate additional geometric data
geom = calculate_geometry(geom);

% Input material data
material.E_m = 4300;
material.nu_m = 0.35;
material.plstrain = 1;

% Calculate additional material parameters
% Lame modulus
material.mu_m = material.E_m/(2*(1 + material.nu_m));       
% Lame modulus
material.lambda_m = (material.E_m * material.nu_m)/((1 + material.nu_m)*(1-2*material.nu_m));  
% Plane strain kappa
material.kappa_m = 3 + 4*material.nu_m;

% Problem-specific data

alphalist = [-2 -1 -0.5 0 0.5 1 2];
omegalist = [0 pi/6 pi/4 pi/3 pi/2];


for alpha = alphalist
  N1 = 1;
  N2 = alpha;
  for omega = omegalist

    %---------------------------------------------------------------
    % Hand-calc solution for farfield loading
    %==============================================================

    for jj=1:geom.NumPoints
      [phi_check(jj), phiprime_check(jj), psi_check(jj)] ...
          = check_farfield_circle(geom.R, geom.theta(jj), alpha, omega); 
      disp_check(jj)=calculatedisplacement(phi_check(jj), phiprime_check(jj), ...
                                         psi_check(jj), geom.theta(jj), geom.m, material);
      dispxy_check(jj)=disp_check(jj)*exp(i*geom.beta(jj));
    end


    %---------------------------------------------------------------
    % My solution for far field loading
    %===============================================================

    for jj=1:geom.NumPoints
      [phi(jj), phiprime(jj),psi(jj)] = ...
          farfieldpotential(geom.theta(jj), geom.rho, geom.R, geom.m, ...
                            N1, N2, omega); 
      disp(jj) = calculatedisplacement(phi(jj), phiprime(jj), psi(jj), ...
                                       geom.theta(jj), geom.m, material);
      dispxy(jj)=disp(jj)*exp(i*geom.beta(jj));
    end

    
    assert(allequal(disp, disp_check, epsilon), ...
           ['displacement does not match for alpha = ' ...
            num2str(alpha) ' and omega = ' num2str(omega)] )


    assert(allequal(phi, phi_check, epsilon), ...
           ['phi does not match for alpha = ' ...
            num2str(alpha) ' and omega = ' num2str(omega)] )
    
    assert(allequal(phiprime, phiprime_check, epsilon), ...
           ['phiprime does not match for alpha = ' ...
            num2str(alpha) ' and omega = ' num2str(omega)] )
    

    assert(allequal(psi, psi_check, epsilon), ...
           ['psi does not match for alpha = ' ...
            num2str(alpha) ' and omega = ' num2str(omega)] )
    
  end
end
