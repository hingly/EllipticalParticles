function test_calculate_geometry_circle

epsilon=1e-5;

geom.NumPoints=7;
geom.a=10;
geom.b=geom.a;

geom=calculate_geometry(geom);

assert(almostequal(geom.theta, geom.beta, epsilon),...
       'theta and beta should be equal for a circle');

assert(almostequal(geom.theta, geom.alpha, epsilon), ...
       'theta and alpha should be equal for a circle');

for kk=1:geom.NumPoints
  radius(kk)=sqrt(geom.ellipse(1,kk)^2+geom.ellipse(2,kk)^2);
end

assert(almostequal(radius,geom.a,epsilon),...
       'radius must equal a')
assert(almostequal(radius,geom.b,epsilon),...
       'radius must equal b')



