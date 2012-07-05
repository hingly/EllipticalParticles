function disp=calculatedisplacement(phi, phiprime, psi, theta, mu, kappa, m)

% Calculates the displacement vector at a given location theta,
% given potential functions

% Note displacement is a complex number, u+iv

A1=(1-m*exp(2*i*theta))/(sqrt(1-2*m*cos(2*theta)+m^2));
A2=(exp(i*theta)+ m*exp(-i*theta))/(1 - m * exp(2*i*theta));

disp1=kappa*phi - A2*conj(phiprime) -conj(psi);
disp2=A1*exp(-i*theta)/(2*mu);
disp=disp1*disp2;



%*** I don't think these are called from anywhere else so they
%might as well sit in this subroutine

%A1=A1func(theta,m);
%A2=A2func(theta,m);
