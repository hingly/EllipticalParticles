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


