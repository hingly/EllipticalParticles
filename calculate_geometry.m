function geom=calculate_geometry(geom)

% Calculates the (x,y) position, and each different type of angle
% for each point around the ellipse



n=geom.NumPoints;
a=geom.a;
b=geom.b;

% initialising arrays
theta=zeros(1,n+1);             % angle in zeta-plane
ellipse=zeros(2,n+1);            % coordinates of points around the ellipse
beta=zeros(1,n+1);               % normal angle
alpha=zeros(1,n+1);              % polar angle
normal=zeros(1,n+1);               % normal vector (complex)


for kk=1:n+1    % Loop over integration points to calculate geometric quantities

    % Compute angles and coordinates
    theta(kk)=2*pi*(kk-1)/n;
    ellipse(1,kk)=a*cos(theta(kk));
    ellipse(2,kk)=b*sin(theta(kk));
% FIXME : Why is ellipse not stored as a complex variable?

    beta(kk)=atan(a/b*tan(theta(kk)));           % angle of the normal to the surface
    alpha(kk)=atan(b/a*tan(theta(kk)));          % polar angle

    % correct for arctan errors
    if theta(kk)<=pi/2;
        beta(kk)=beta(kk);
        alpha(kk)=alpha(kk);
    elseif (theta(kk)>pi/2) && (theta(kk)<=3*pi/2)
        beta(kk)=beta(kk)+pi;
        alpha(kk)=alpha(kk)+pi;
    elseif (theta(kk)>3*pi/2) && (theta(kk)<=2*pi)
        beta(kk)=beta(kk)+2*pi;
        alpha(kk)=alpha(kk)+2*pi;
    else
        theta(kk)
        error('what size is theta anyway?')
    end
    normal(kk)=exp(i*beta(kk));
end

normal(kk)=exp(i*beta(kk));

geom.theta=theta;
geom.beta=beta;
geom.alpha=alpha;
geom.ellipse=ellipse;
geom.normal=normal;