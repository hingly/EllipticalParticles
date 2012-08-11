function[sigmap, epsint] = averages(dispxy, Tcohxy, geom)

% This subroutine calculates volume averages of interfacial strain
% (equations 4.73-4.75) and particle stress (equations 4.76-4.78)

% --- dispxy is the displacement of the points on the interface in
%            x,y coords, complex vector length NumPoints
% --- Tcohxy is the cohesive traction in x,y coords, complex vector length NumPoints
% --- geom is a structure containing geometric data

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


% area of the ellipse
volume = pi*a*b;   

% incremental angle
dtheta=2*pi/NumPoints;          

%conversion from incremental angle to incremental length on circumference
dS = R*dtheta*sqrt(1 - 2*m*cos(2*theta)+m^2);    

epsint(1)=sum(real(dispxy).*real(normal).*dS);
epsint(2)=sum(imag(dispxy).*imag(normal).*dS);
epsint(3)=sum((real(dispxy).*imag(normal) + imag(dispxy).*real(normal))/2.*dS); 

sigmap(1)=sum(real(Tcohxy).*real(ellipse).*dS);
sigmap(2)=sum(imag(Tcohxy).*imag(ellipse).*dS);
%sigmap(3)=sum((real(Tcohxy).*imag(ellipse) + imag(Tcohxy).*real(ellipse))/2.*dS);
sigmap(3)=sum(real(Tcohxy).*imag(ellipse).*dS)
sigmaptest=sum(imag(Tcohxy).*real(ellipse).*dS);
assert(almostequal(sigmap(3),sigmaptest,1e-10),'sigmap not symmetric');

% FIXME : I don't think that sigmap(3) should be 12 + 21 - should
% calculate 12 and 21 and compare


epsint=epsint/volume;
sigmap=sigmap/volume;


