function test_calculate_geometry_circle

epsilon=1e-5;

geom.NumPoints=7;
geom.a=10;
geom.b=10;

geom=calculate_geometry(geom);

assert(almostequal(geom.theta, geom.beta, epsilon),...
       'theta and beta should be equal for a circle');

assert(almostequal(geom.theta, geom.alpha, epsilon), ...
       'theta and alpha should be equal for a circle');




