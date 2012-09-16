function [phi, phiprime, psi] = ...
    timoshenko_farfield(m, R, theta, S, beta)


% Geometric constants
sigma = exp(i*theta);

coefficient = -S*R/2;

% Calculate potential phi
phi1 = (m - exp(2*i*beta))/sigma;
phi = phi1*coefficient;

% Calculate potential phiprime
phiprime1 = -(m - exp(2*i*beta))/sigma^2;
phiprime = phiprime1*coefficient;

% Calculate potential psi
psi1 = (m - exp(2*i*beta))*(1 + m*sigma^2)/(sigma*(sigma^2 - m));
psi2 = (1 - m*exp(-2*i*beta))/sigma;
psi = (psi1 + psi2)*coefficient;




