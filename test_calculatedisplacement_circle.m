function test_calculatedisplacement_circle

epsilon=1e-10;

material.E_m = 4300;
material.nu_m = 0.35;

% Lame modulus
material.mu_m = material.E_m/(2*(1 + material.nu_m));       
% Bulk modulus
material.kappa_m = 3 + 4*material.nu_m;


geom.a = 10;
geom.b = 10;
geom.NumPoints = 20;

geom = calculate_geometry(geom);


%--------------------------------------------------
% For a circular hole under equibiaxial loading
%=================================================

N1 = 10;

phi = geom.R*N1*exp(i*geom.theta)/2;
phiprime = geom.R*N1/2*ones(1, geom.NumPoints);
psi = -geom.R*N1*exp(-i*geom.theta);

disp = zeros(1, geom.NumPoints);

for jj = 1:geom.NumPoints
  disp(jj)=calculatedisplacement(phi(jj), phiprime(jj), psi(jj), geom.theta(jj), geom.m, material);
end
disp_check=ones(1, geom.NumPoints)*geom.R*N1*(material.kappa_m+1)/(4*material.mu_m);

assert(imag(disp)<epsilon, 'Tangential displacement not calculated correctly')
assert(allequal(real(disp), disp_check, epsilon), ['Normal displacement ' ...
                    'not calculated correctly'])


%--------------------------------------------------
% For a circular hole under general loading
%=================================================

% Can't test all details but can look for key features



alphalist = [-2 -1 -0.5 0 0.5 1 2];
omega = 0;


for alpha = alphalist
  N1 = 1;
  N2 = alpha;

  %---------------------------------------------------------------
  % Hand-calc solution for farfield loading
  %==============================================================

  for jj=1:geom.NumPoints
    [phi_check(jj), phiprime_check(jj), psi_check(jj)] ...
        = check_farfield_circle(geom.R, geom.theta(jj), alpha, omega); 
    disp_check(jj) = ...
        calculatedisplacement(phi_check(jj), phiprime_check(jj), ...
                              psi_check(jj), geom.theta(jj), geom.m, material);
    dispxy_check(jj)=disp_check(jj)*exp(i*geom.beta(jj));
    
    if mod(geom.theta(jj), pi/2) < epsilon
      assert(imag(disp_check(jj)) < epsilon, ...
             ['Tangential displacement is ' num2str(imag(disp_check(jj))) ...
              ' for theta = ' num2str(geom.theta(jj)) ' alpha = ' ...
              num2str(alpha) ' and  omega = ' num2str(omega)]);
    end
  end
end






