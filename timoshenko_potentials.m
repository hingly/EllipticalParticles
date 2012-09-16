function [phi, phiprime, psi]=timoshenko_potentials(m, R, theta, theta0, p)

% Geometric constants
sigma=exp(i*theta);
barsigma=conj(sigma);

% Loading parameters
sigma0=exp(i*theta0);
barsigma0=conj(sigma0);

coefficient=2*pi*i/(p*R);


% Calculate potential phi
phi1=-4*m*log(sigma0)/sigma;
phi2=(sigma+m/sigma)*log((sigma^2-sigma0^2)/(sigma^2-barsigma0^2));
phi3=(sigma0+m/sigma0)*log((sigma+sigma0)/(sigma-sigma0));
phi4=(1/sigma0+m*sigma0)*log((sigma-barsigma0)/(sigma+barsigma0));

phi=(phi1 + phi2 + phi3 + phi4)/coefficient;

% Calculate potential phiprime
phiprime1=4*m*log(sigma0)/sigma^2;
phiprime2=(1-m/sigma^2)*log((sigma^2-sigma0^2)/(sigma^2-barsigma0^2));
phiprime2a=2*(m+sigma^2)/(sigma^2-sigma0^2)*(sigma0^2-barsigma0^2)/(sigma^2-barsigma0^2);
phiprime3=-2*(m+sigma0^2)/(sigma^2-sigma0^2);
phiprime4=2*(1+m*sigma0^2)/(sigma^2-barsigma0^2)*barsigma0/sigma0;

phiprime=(phiprime1 + phiprime2 + phiprime2a + phiprime3 + phiprime4)/coefficient;

% Calculate potential psi
psi1=-4*log(sigma0)*(1+m^2)*(sigma)/(sigma^2-m);
psi2=(sigma0+m/sigma0)*log((sigma-barsigma0)/(sigma+barsigma0));
psi3=(1/sigma0+m*sigma0)*log((sigma+sigma0)/(sigma-sigma0));

psi=(psi1 + psi2 + psi3)/coefficient;


% In my code, positive force on the boundary acts to close the hole
% --- need to change signs on potentials to correct for this.

phi = -phi;
phiprime = -phiprime;
psi = -psi;