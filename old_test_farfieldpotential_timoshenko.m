function old_test_farfieldpotential_timoshenko

% Test of farfieldpotential.m subroutine by comparing potentials output with
% those given in Timoshenko and Goodier  pp214-215,
% Fig124

%---------------------------------
% Input data
%=================================  

% Input geometric data
geom.a = 10;
geom.b = 5;
geom.NumPoints = 402;

% Calculate additional geometric data
geom = calculate_geometry(geom);

% Input material data
material.E_m = 4300;
material.nu_m = 0.35;
material.plstrain = 1;

% Calculate additional material parameters
% Lame modulus
material.mu_m = material.E_m/(2*(1 + material.nu_m));       
% Lame modulus
material.lambda_m = (material.E_m * material.nu_m)/((1 + material.nu_m)*(1-2*material.nu_m));  
% Plane strain kappa
material.kappa_m = 3 + 4*material.nu_m;

% Problem-specific data

Slist = [100 -100];
omegalist = [0 pi/6 pi/4 pi/3 pi/2];

for S = Slist
  N1 = S;
  N2 = 0;
  for omega = omegalist
    
    epsilon = 1e-10;

    %---------------------------------------------------------------
    % Timoshenko solution for farfield loading
    %==============================================================

    for jj=1:geom.NumPoints
      [phi_tim(jj), phiprime_tim(jj), psi_tim(jj)] ...
          = timoshenko_farfield(geom.m, geom.R, geom.theta(jj), S, omega); 
      disp_tim(jj)=calculatedisplacement(phi_tim(jj), phiprime_tim(jj), ...
                                         psi_tim(jj), geom.theta(jj), geom.m, material);
      dispxy_tim(jj)=disp_tim(jj)*exp(i*geom.beta(jj));
    end


    %---------------------------------------------------------------
    % My solution for far field loading
    %===============================================================

    for jj=1:geom.NumPoints
      [phi(jj), phiprime(jj),psi(jj)] = ...
          farfieldpotential(geom.theta(jj), geom.rho, geom.R, geom.m, ...
                            N1, N2, omega); 
      disp(jj) = calculatedisplacement(phi(jj), phiprime(jj), psi(jj), ...
                                       geom.theta(jj), geom.m, material);
      dispxy(jj)=disp(jj)*exp(i*geom.beta(jj));
    end

%         figure
%          plot(geom.theta, real(phi_tim),'r-',geom.theta, real(phi),'rx', ...
%            geom.theta, imag(phi_tim),'b-',geom.theta, imag(phi),'bx');

    phi_error = -phi_tim + phi;
  %       figure
  %       plot(geom.theta, real(phi_error),'r', geom.theta, imag(phi_error),'b');


%     figure
%     plot(geom.theta, real(phiprime_tim),'r-',geom.theta, real(phiprime),'rx', ...
%          geom.theta, imag(phiprime_tim),'b-',geom.theta, imag(phiprime),'bx');

    phiprime_error = -phiprime_tim + phiprime;
  %   figure(4)
  %    plot(geom.theta, real(phiprime_error),'r', geom.theta, imag(phiprime_error),'b')

%      figure
%      plot(geom.theta, real(psi_tim),'r-',geom.theta, real(psi),'rx', ...
%           geom.theta, imag(psi_tim),'b-',geom.theta, imag(psi),'bx');

    psi_error = -psi_tim + psi;
  %    figure(6)
  %    plot(geom.theta, real(psi_error),'r', geom.theta, imag(psi_error),'b');


%         figure
%         plot(geom.theta, real(disp_tim),'r-', geom.theta, real(disp), 'rx',...
%              geom.theta, imag(disp_tim),'b-', geom.theta, imag(disp), ...
%              'bx');

    disp_error = -disp_tim + disp;
  %       figure
  %  plot(geom.theta, real(disp_error),'r', geom.theta, imag(disp_error),'b');


    assert(allequal(disp, disp_tim, epsilon), ...
           ['displacement does not match for S = ' ...
            num2str(S) ' and omega = ' num2str(omega)] )

    %assert(allequal(phi, phi_tim, epsilon), ...
    %       ['phi not calculated correctly for pressure =' ...
    %        num2str(pressure) ' theta0 = ' num2str(theta0)])

    % FIXME : How to compare values with spikes in them?  get large
    % local errors.

    %  assert(allequal(phiprime, phiprime_tim,epsilon), ...
    %         'phiprime not calculated correctly') 

    %  assert(allequal(psi, psi_tim,epsilon), ...
    %         'psi not calculated correctly')

  end
end      


