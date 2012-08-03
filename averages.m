function[sigmap, epsint] = averages(dispxy, Tcohxy, geom)


% Edited July 3, 2012



% This subroutine calculates volume averages of interfacial strain
% (equations 4.73-4.75) and particle stress (equations 4.76-4.78)

% --- dispxy is the displacement of the points on the interface in x,y coords, vector length NumPoints+1
% --- Tcohxy is the cohesive traction in x,y coords, vector length NumPoints+1
% --- geom is a structure containing geometric data


% --- NumPoints is the number of integration points around the ellipse
NumPoints=geom.NumPoints;

% --- theta is the angle in the zeta-plane, vector length NumPoints+1
theta=geom.theta;

% --- beta is the angle of the normal to the ellipse in the z-plane, vector length NumPoints+1
beta=geom.beta;

% --- a, b, R, m are geometric quantities, same definition as elsewhere
a=geom.a;
b=geom.b;
R=geom.R;
m=geom.m;



sigmap=zeros(1,3);
epsint=zeros(1,3);
volume = pi*a*b;   % area of the ellipse

for kk=1:NumPoints+1
   dtheta=2*pi/NumPoints;          % incremental angle
   dS = R*dtheta*sqrt(1 - 2*m*cos(2*theta(kk))+m^2);    
   %conversion from incremental angle to incremental length on circumference
                                                      
   epsint(1)=epsint(1)+real(dispxy(kk))*cos(beta(kk))*dS; 
   epsint(2)=epsint(2)+imag(dispxy(kk))*sin(beta(kk))*dS; 
   epsint(3)=epsint(3)+(real(dispxy(kk))*sin(beta(kk)) + imag(dispxy(kk))*cos(beta(kk)))/2*dS; 
   
   sigmap(1)=sigmap(1)+real(Tcohxy(kk))*a*cos(theta(kk))*dS;
   sigmap(2)=sigmap(2)+imag(Tcohxy(kk))*b*sin(theta(kk))*dS;
   sigmap(3)=sigmap(1)+(real(Tcohxy(kk))*b*sin(theta(kk))+ imag(Tcohxy(kk))*a*cos(theta(kk)))/2*dS;
     
   
   
end


epsint=epsint/volume;
sigmap=sigmap/volume;
