function [phi, phiprime,psi]=modes(theta,rho,R, m, NumModes, forcecoeff)

% Calculates potentials due to Fourier force coefficients on the
% surface of the ellipse.  --- equations 4.53, 4.54 and 4.55



sigma=exp(i*theta);
zeta=rho*sigma;


phi_k=zeros(1,NumModes+1);
phiprime_k=zeros(1,NumModes+1);
psi_k=zeros(1,NumModes+1);


phi=0;
phiprime=0;
psi=0;


for jj=-NumModes:2:NumModes
    jindex=jj/2+NumModes/2+1;
    if jj<=-2
       phi_k(jindex)=R*forcecoeff(jindex)*((zeta^(jj+1))/(jj+1) - m*(zeta^(jj-1))/(jj-1));
       phiprime_k(jindex)=R*forcecoeff(jindex)*(zeta^(jj) - m*zeta^(jj-2));
       psi_k(jindex)=-R*forcecoeff(jindex)*(1+m*zeta^2)/(zeta^2-m)*(zeta^(jj+1) - m*zeta^(jj-1));
    elseif jj==0
       phi_k(jindex) = R*forcecoeff(jindex)*m/zeta;
       phiprime_k(jindex) = -R*forcecoeff(jindex)*m/(zeta^2);
       psi_k(jindex) = R*forcecoeff(jindex)*zeta*(1+m^2)/(zeta^2-m);
    elseif jj>=2
       phi_k(jindex)=0;
       phiprime_k(jindex)=0; 
       psi_k(jindex)=R*conj(forcecoeff(jindex))*((zeta^(-jj-1))/(jj+1)-m*(zeta^(-jj+1))/(jj-1));
   end
    phi=phi+phi_k(jindex);
    phiprime=phiprime+phiprime_k(jindex);
    psi=psi+psi_k(jindex);
end


