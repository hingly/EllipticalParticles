function d = distance_point_to_line(pt, v1, v2)

%In this function, pt, v1, and v2 are the three-dimensional
% coordinates of the point, one vertex on the line, and a second
% vertex on the line, respectively. The following example illustrates
% how this function would be called:
%v1 = [0,0,0];
%v2 = [3,0,0];
%pt = [0,5,0];
%distance = point_to_line(pt,v1,v2)

assert(length(pt) == length(v1) & length(v1) == length(v2), ...
       'all arguments must have the same dimension');
    
% Generalised formulation from http://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#Vector_formulation
b = v1 - pt;
n = (v2 - v1)/norm(v2 - v1);
d = norm(b - dot(b, n)*n);
