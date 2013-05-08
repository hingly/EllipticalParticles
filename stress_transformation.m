function [stressvecnew] = stress_transformation(stressvec, alpha)

% This subroutine finds the stress state in a coordinate system
% rotated by angle alpha.
%
% stressvec is expected to be a row vector

c = cos(alpha);
s = sin(alpha);

transmatrix = [c^2 s^2 2*s*c;s^2 c^2 -2*s*c;-s*c s*c c^2-s^2];

stressvecnew = (transmatrix*stressvec')';


