function [S1, S2, alpha] = principal(s11, s22, s12)

% This subroutine computes the principal stresses and direction
% [-pi/2, pi/2] given the three components of a 2D stress state.



S1=(s11+s22)/2 + sqrt(((s11-s22)/2)^2 + (s12)^2);

S2=(s11+s22)/2 - sqrt(((s11-s22)/2)^2 + (s12)^2);

alpha=atan2(2*s12, (s11-s22))/2;

