function[sigmap, epsint, out_error] = averages(dispxy, Tcohxy, geom, warningflag)

if ~exist('warningflag', 'var')
  warningflag = false;
end


% This subroutine calculates volume averages of interfacial strain
% (equations 4.73-4.75) and particle stress (equations 4.76-4.78)

% --- dispxy is the displacement of the points on the interface in
%            x,y coords, complex vector length NumPoints
% --- Tcohxy is the cohesive traction in x,y coords, complex vector length NumPoints
% --- geom is a structure containing geometric data
% --- warningflag tells whether to print warnings about symmetry of Sigma_p

% --- NumPoints is the number of integration points around the ellipse
NumPoints=geom.NumPoints;

% --- theta is the angle in the zeta-plane, vector length NumPoints
theta=geom.theta;

% --- beta is the angle of the normal to the ellipse in the z-plane, vector length NumPoints
beta=geom.beta;

% --- normal is the normal vector to the ellipse
normal=geom.normal;

% --- ellipse is the coordinates of points on the ellipse (i.e. x+iy)
ellipse=geom.ellipse;


% --- a, b, R, m are geometric quantities, same definition as elsewhere
a=geom.a;
b=geom.b;
R=geom.R;
m=geom.m;

% Error tolerance
epsilon=1e-6;

% area of the ellipse
volume = pi*a*b;   

% incremental angle
dtheta=2*pi/NumPoints;          

%conversion from incremental angle to incremental length on circumference
dS = R*dtheta*sqrt(1 - 2*m*cos(2*theta)+m^2); 

epsint(1)=sum(real(dispxy).*real(normal).*dS);
epsint(2)=sum(imag(dispxy).*imag(normal).*dS);
epsint(3)=sum((real(dispxy).*imag(normal) + imag(dispxy).*real(normal))/2.*dS); 

sigmap(1) = sum(real(Tcohxy).*real(ellipse).*dS);
sigmap(2) = sum(imag(Tcohxy).*imag(ellipse).*dS);
sigmap(3) = sum(real(Tcohxy).*imag(ellipse).*dS);
sigmap(4) = sum(imag(Tcohxy).*real(ellipse).*dS);

symm_error = norm(sigmap(3)-sigmap(4));
if symm_error > epsilon
  if warningflag
    warning(['Sigmap is not symmetric ... error of ' num2str(symm_error) ...
             ' on ' num2str(sigmap(3)) '. Angular momentum is not conserved.'])
  end
end


epsint=epsint/volume;
sigmap=sigmap/volume;


if nargout > 2
  out_error = symm_error;
end
