function [phi, phiprime, psi] = farfieldpotential(theta, rho, R, m, N1, N2, omega)


% Given far-field loading as a principal stress state plus
% orientation (N1, N2, omega), calculate the potential functions
% for far-field loading of a traction-free hole


% Note: I am never calculating stresses, so am not calculating
% phiprime2 and psiprime  --- 16/7/2012

sigma = exp(i*theta);
zeta = rho*sigma;

% Calculate the potential functions on the ellipse, since that is 
% where we want to know displacements.

Q = (N1 + N2)/4.0;
P = (N1 - N2)/2.0;

phi = Q*R*zeta - Q*R*m./zeta + P*R*exp(2*i*omega)./zeta;

phiprime = Q*R + Q*R*m./zeta.^2 - P*R*exp(2*i*omega)./zeta.^2;

psi = -P*R*exp(-2*i*omega).*zeta - ...
      R*((1 + m^2)*2*Q.*zeta.^2 - (1 + m*zeta.^2)*P.*exp(2* i*omega))./(zeta.*(zeta.^2 - m));



% phiprime2 = -2*Q*R*m/zeta^3 + 2*P*R*exp(2*i*omega)/zeta^3;

% psiprime = -P*R*exp(-2*i*omega) + R*2*Q*(zeta^2+m)*(1+m^2)/((zeta^2-m)^2) - P*R*exp(2*i*omega)*(m*zeta^4 + m^2*zeta^2 + 3*zeta^2 - m)/(zeta^2*(zeta^2-m)^2);

