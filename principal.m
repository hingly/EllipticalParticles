function [S1, S2, alpha] = principal(s11, s22, s12)

% This subroutine computes the principal stresses and direction given the
% three components of a 2D stress state.



S1=(s11+s22)/2 + sqrt(((s11-s22)/2)^2 + (s12)^2);

S2=(s11+s22)/2 - sqrt(((s11-s22)/2)^2 + (s12)^2);


if (s11-s22) ==0
    alpha=pi/4*sign(s12);
else
    tan2alpha=2 * s12/(s11-s22);
    if (s11-s22) >=0
        alpha = atan(tan2alpha)/2;
    else
        if s12 <=0
            alpha = (atan(tan2alpha)- pi)/2;
        else
            alpha = (atan(tan2alpha)+ pi)/2;
        end
    end
end

