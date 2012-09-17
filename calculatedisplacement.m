function disp=calculatedisplacement(phi, phiprime, psi, theta, m, material)

mu = material.mu_m;
kappa = material.kappa_m;

% Calculates the displacement vector at a given location theta,
% given potential functions

% Note displacement is a complex number, u+iv

[A1, A2] = Afunc(m, theta);

disp1=kappa*phi - A2*conj(phiprime) - conj(psi);
disp2=A1*exp(-i*theta)/(2*mu);
disp=disp1*disp2;


