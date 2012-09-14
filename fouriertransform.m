function coeff=fouriertransform(force, theta, NumModes)

% This subroutine calculates the Fourier coefficients f_k to apply
% a known force.  
% --- force is a vector, length NumPoints, containing forces (complex)
% --- theta is a vector, length NumPoints, containing angles
% --- NumPoints is the number of points around the ellipse at which we
%          evaluate quantities (must be an even number)
% --- NumModes is the number of modes in the Fourier series (must be
%          an even number)
% --- coeff is the Fourier coefficients, output of the transform


assert(length(force)==length(theta),...
       'force and theta are expected to be the same length');
assert(mod(NumModes,2)==0,...
       'NumModes must be even');

NumPoints=length(theta);

assert(mod(NumPoints,2)==0,...
       'NumPoints must be even');
assert(NumPoints>NumModes, ...
       'NumPoints must be bigger than NumModes');

dtheta=2*pi/NumPoints;            % integration step
coeff=zeros(1,NumModes+1);

for jj = -NumModes:2:NumModes           % loop over modes
    index = jj/2+NumModes/2+1;
    coeff(index) = sum(force.*exp(-i*jj*theta)*dtheta);
end
coeff = coeff/(2*pi);

