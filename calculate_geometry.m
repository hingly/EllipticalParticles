function geom=calculate_geometry(geom)

% Calculates the (x,y) position, and each different type of angle
% for each point around the ellipse


NumPoints=geom.NumPoints;
a=geom.a;
b=geom.b;
 


%-------------------------------------------
% Calculate additional geometric parameters
%-------------------------------------------

% ellipse size factor
geom.R=(geom.a+geom.b)/2.;                      
% ellipse shape factor
geom.m=(geom.a-geom.b)/(geom.a+geom.b);         
% Hard-coded - we never use a different rho
geom.rho=1;

%-----------------------------
% Calculate  geometric arrays
%-----------------------------

zero_intpoints=zeros(1,geom.NumPoints);

% initialising arrays

% angle in zeta-plane
theta=zero_intpoints;             
% coordinates of points around the ellipse (complex)
ellipse=zero_intpoints;           
% normal angle
beta=zero_intpoints;               
% normal vector (complex)
normal=zero_intpoints;              


% Create theta with NumPoints + 1 entries, and then drop the last
% one, which is 2*pi.
theta=linspace(0,2*pi,NumPoints+1);
theta=theta(1:NumPoints);

%coordinates of the ellipse
ellipse=a*cos(theta) + i*b*sin(theta);

% angle of the normal to the surface
beta = unwrap(atan2(a*sin(theta), b*cos(theta)));

% normal vector
normal=exp(i*beta);


geom.theta=theta;
geom.beta=beta;
geom.ellipse=ellipse;
geom.normal=normal;