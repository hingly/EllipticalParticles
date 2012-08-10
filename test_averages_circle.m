function test_averages_circle


% --- dispxy is the displacement of the points on the interface in x,y coords, vector length NumPoints+1
% --- Tcohxy is the cohesive traction in x,y coords, vector length NumPoints+1
% --- geom is a structure containing geometric data

geom.NumPoints=100;
geom.a=10;
geom.b=10;

geom=calculate_geometry(geom);

% FIXME : write test for calculate_geometry

%[sigmap, epsint] = averages(dispxy, Tcohxy, geom);