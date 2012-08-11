function test_averages_circle

epsilon=1e-10;

% --- dispxy is the displacement of the points on the interface in x,y coords, vector length NumPoints
% --- Tcohxy is the cohesive traction in x,y coords, vector length NumPoints
% --- geom is a structure containing geometric data

geom.NumPoints=100;
geom.a=10;
geom.b=10;

geom=calculate_geometry(geom);

dispxy=geom.ellipse;
Tcohxy=zeros(1,geom.NumPoints);

[sigmap, epsint] = averages(dispxy, Tcohxy, geom);

epsintcheck = [1 1 0];
assert(almostequal(epsint,epsintcheck,epsilon),'failed at epsint');

sigmapcheck=zeros(1,3);
assert(almostequal(sigmap,sigmapcheck,epsilon),'failed at sigmap');


