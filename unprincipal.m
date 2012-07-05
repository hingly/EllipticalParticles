function [s11, s22, s12] = unprincipal(S1, S2, alpha)

% This subroutine computes the stress state in Cartesian coordinates given 
% principal directions and angle
%
% NOTE: Since we are transforming back from principal stresses, the angle
%       to be used in the transformation is the negative of the angle given.
%       Also, the shear stress in the principal stress state is zero.

alpha=-alpha;

s11=(S1+S2)/2 + (S1-S2)/2*cos(2*alpha);

s22=(S1+S2)/2 - (S1-S2)/2*cos(2*alpha);

s12=-(S1-S2)/2*sin(2*alpha);




