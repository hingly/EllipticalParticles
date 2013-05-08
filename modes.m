function [phi, phiprime, psi] = modes(theta, rho, R, m, NumModes, forcecoeff)

% Calculates potentials due to Fourier force coefficients on the
% surface of the ellipse.  --- equations 4.53, 4.54 and 4.55
% This function will vectorise in terms of theta and forcecoeff

% Vectorisation strategy:
%   We assemble phi, phiprime and psi as matrices, varying
%  +----> thetas (NumTheta+1)
%  |
%  v
% Modes (forcecoeff, NumModes)

% in the end we sum along the modes, for each theta, which is the
% default behaviour for sum()

forcecoeff = forcecoeff'; % forcecoeff must be a column vector - one entry per mode

sigma = exp(i*theta);
zetavec = rho*sigma;

NumTheta = length(theta);

phi_k = zeros(NumModes+1, NumTheta);
phiprime_k = zeros(NumModes+1, NumTheta);
psi_k = zeros(NumModes+1, NumTheta);

phi = 0;
phiprime = 0;
psi = 0;

% Negative j
[zeta, jj] = meshgrid(zetavec, -NumModes:2:-2);
jindex = jj/2 + NumModes/2 + 1;
flatjindex = jindex(:, 1);
phi_k(flatjindex, :) = R*forcecoeff(jindex).*((zeta.^(jj+1))./(jj+1) - m*(zeta.^(jj-1))./(jj-1));
phiprime_k(flatjindex, :) = R*forcecoeff(jindex).*(zeta.^(jj) - m*zeta.^(jj-2));
psi_k(flatjindex, :) = -R*forcecoeff(jindex).*(1 + m*zeta.^2)./(zeta.^2 - m).*(zeta.^(jj+1) - m*zeta.^(jj-1));

jj = 0;
zeta = zetavec;
jindex = jj/2 + NumModes/2 + 1;
flatjindex = jindex(:, 1);
phi_k(flatjindex, :) = R*forcecoeff(jindex)*m./zeta;
phiprime_k(flatjindex, :) = -R*forcecoeff(jindex)*m./(zeta.^2);
psi_k(flatjindex, :) = R*forcecoeff(jindex).*zeta*(1 + m^2)./(zeta.^2 - m);

% positive j
[zeta, jj] = meshgrid(zetavec, 2:2:NumModes);
jindex = jj/2 + NumModes/2 + 1;
flatjindex = jindex(:, 1);
phi_k(flatjindex, :) = 0;
phiprime_k(flatjindex, :) = 0; 
psi_k(flatjindex, :) = R*conj(forcecoeff(jindex)).*((zeta.^(-jj-1))./(jj+1) - m*(zeta.^(-jj+1))./(jj-1));

phi = sum(phi_k, 1);
phiprime = sum(phiprime_k, 1);
psi = sum(psi_k, 1);
