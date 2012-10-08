function [phi, phiprime, psi] = ...
    check_farfield_circle(R, theta, alpha, omega)

% Potential functions for general loading of a circular hole.  

% Geometric constants
sigma = exp(i*theta);

coefficient = R/2;

% Calculate potential phi
phi1 = (1 + alpha)*sigma/2;
phi2 = (1 - alpha)*exp(2*i*omega)/sigma;
phi = (phi1 + phi2)*coefficient;

% Calculate potential phiprime
phiprime1 = (1 + alpha)/2;
phiprime2 = - (1 - alpha)*exp(2*i*omega)/sigma^2;
phiprime = (phiprime1 + phiprime2)*coefficient;

% Calculate potential psi
psi1 = (alpha - 1)*exp(-2*i*omega)*sigma;
psi2 = - (1 + alpha)/sigma;
psi3 = (1 - alpha)*exp(2*i*omega)/sigma^3;
psi = (psi1 + psi2 + psi3)*coefficient;




