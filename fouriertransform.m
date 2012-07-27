function coeff=fouriertransform(force,theta,NumPoints,NumModes)


% Edited July 3, 2012


% This subroutine calculates the Fourier coefficients f_k to apply
% a known force.  
% --- force is a vector, length NumPoints+1, containing forces
% --- theta is a vector, length NumPoints+1, containing angles
% --- NumPoints is the number of points around the ellipse at which we
%          evaluate quantities
% --- NumModes is the number of modes in the Fourier series (must be
%          an even number)
% --- coeff is the Fourier coefficients, output of the transform


dtheta=2*pi/NumPoints;            % integration step
coeff=zeros(1,NumModes/2+1);

% for jj=0:2:NumModes           % loop over modes
%     index=jj/2+1;
%     coeff(index)=0;
%     for kk=1:NumPoints
%         coeff(index)=coeff(index)+force(kk)*exp(-i*jj*theta1(kk))*dtheta;
%     end 
% end
% coeff=coeff/(2*pi);

for jj=-NumModes:2:NumModes           % loop over modes
    index=jj/2+NumModes/2+1;
    coeff(index)=0;
    for kk=1:NumPoints
        coeff(index)=coeff(index)+force(kk)*exp(-i*jj*theta(kk))*dtheta;
    end 
end
coeff=coeff/(2*pi);

