function geom=calculate_geometry(geom)

% Calculates the (x,y) position, and each different type of angle
% for each point around the ellipse

%disp('Calculating geometry...');

NumPoints=geom.NumPoints;
a=geom.a;
b=geom.b;
 
%-------------------------------------------
% Calculate additional geometric parameters
%-------------------------------------------


geom.R=(geom.a+geom.b)/2.;                      
% ellipse size factor
geom.m=(geom.a-geom.b)/(geom.a+geom.b);         
% ellipse shape factor


%-----------------------------
% Calculate  geometric arrays
%-----------------------------

zero_intpoints=zeros(1,geom.NumPoints);

% initialising arrays
theta=zero_intpoints;             % angle in zeta-plane
ellipse=zero_intpoints;            % coordinates of points around the ellipse
beta=zero_intpoints;               % normal angle
alpha=zero_intpoints;              % polar angle
normal=zero_intpoints;               % normal vector (complex)

theta=linspace(0,2*pi,NumPoints+1);
theta=theta(1:NumPoints);

%coordinates of the ellipse
ellipse=a*cos(theta) + i*b*sin(theta);

% FIXME : Why is ellipse not stored as a complex variable?

% angle of the normal to the surface
beta = unwrap(atan2(a*sin(theta), b*cos(theta)));

% normal vector
normal=exp(i*beta);


geom.theta=theta;
geom.beta=beta;
geom.ellipse=ellipse;
geom.normal=normal;