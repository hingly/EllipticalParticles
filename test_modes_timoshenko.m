function test_modes_timoshenko

% Test of modes.m subroutine by comparing potentials output with
% those given in Timoshenko and Goodier for a problem with pressure
% applied symmetrically to a part of the boundary: pp215-217,
% Fig125

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

% Input loads data
loads.NumModes = 200;

% Problem-specific data
theta0list = [pi/2 pi/4 pi/6 pi/9 pi/10]; 
pressurelist = [100 -100];
scale=10;

for theta0 = theta0list
  for pressure = pressurelist

    epsilon = abs(pressure)*1e-1;
    
    %---------------------------------------------------------------
    % Timoshenko solution for pressure on a part of the interface
    %==============================================================
    
    for jj=1:geom.NumPoints
      [phi_tim(jj), phiprime_tim(jj), psi_tim(jj)] ...
          = timoshenko_potentials(geom.m, geom.R, geom.theta(jj), theta0, pressure); 
      disp_tim(jj)=calculatedisplacement(phi_tim(jj), phiprime_tim(jj), ...
                                         psi_tim(jj), geom.theta(jj), geom.m, material);
      dispxy_tim(jj)=disp_tim(jj)*exp(i*geom.beta(jj));
    end
    
    
    %---------------------------------------------------------------
    % Modes solution for pressure on a part of the interface
    %===============================================================
    
    % Setup force vector on interface as a step function
    
    for jj=1:geom.NumPoints
      if geom.theta(jj) <= theta0
        force(jj) = 1;
      elseif (geom.theta(jj) >= (pi-theta0)) && (geom.theta(jj) <= (pi+theta0))
        force(jj) = 1;
      elseif (geom.theta(jj) >= (2*pi-theta0)) && (geom.theta(jj) <= 2*pi)
        force(jj) = 1;
      else
        force(jj) = 0;
      end
    end
    
    % Scale force by pressure
    force = force*pressure;
    
    % Calculate fourier coefficients to represent force
    forcecoeff = fouriertransform(force, geom.theta, loads.NumModes);
    
    for jj=1:geom.NumPoints
      [phi(jj), phiprime(jj),psi(jj)] = modes(geom.theta(jj), geom.rho, geom.R, ...
                                              geom.m, loads.NumModes, forcecoeff);
      disp(jj) = calculatedisplacement(phi(jj), phiprime(jj), psi(jj), ...
                                       geom.theta(jj), geom.m, material);
      dispxy(jj)=disp(jj)*exp(i*geom.beta(jj));
    end
    
    %-----------------------------------------------------------------
    % Compare solutions
    %=================================================================
    
    %      figure
    %      plot(geom.theta, real(phi_tim),'r-',geom.theta, real(phi),'rx', ...
    %           geom.theta, imag(phi_tim),'b-',geom.theta, imag(phi),'bx');
    
    phi_error = -phi_tim + phi;
    %      figure
    %      plot(geom.theta, real(phi_error),'r', geom.theta, imag(phi_error),'b');
    
    
    %  figure(3)
    %  plot(geom.theta, real(phiprime_tim),'r-',geom.theta, real(phiprime),'rx', ...
    %       geom.theta, imag(phiprime_tim),'b-',geom.theta, imag(phiprime),'bx');
    
    phiprime_error = -phiprime_tim + phiprime;
    %  figure(4)
    %  plot(geom.theta, real(phiprime_error),'r', geom.theta, imag(phiprime_error),'b')
    
    %  figure(5)
    %  plot(geom.theta, real(psi_tim),'r-',geom.theta, real(psi),'rx', ...
    %       geom.theta, imag(psi_tim),'b-',geom.theta, imag(psi),'bx');
    
    psi_error = -psi_tim + psi;
    %  figure(6)
    %  plot(geom.theta, real(psi_error),'r', geom.theta, imag(psi_error),'b');
    
    
    %     figure
    %     plot(geom.theta, real(disp_tim),'r-', geom.theta, real(disp), 'rx',...
    %          geom.theta, imag(disp_tim),'b-', geom.theta, imag(disp), ...
    %          'bx');
    
    disp_error = -disp_tim + disp;
    %     figure
    %     plot(geom.theta, real(disp_error),'r', geom.theta, imag(disp_error),'b');
    
    %      figure
    %      axis equal;
    %      hold on;
    %      plot(real(geom.ellipse),imag(geom.ellipse), 'LineWidth', 2);
    %      plot(real(geom.ellipse)+scale*real(dispxy), imag(geom.ellipse)+scale*imag(dispxy),'rx-', 'Linewidth', 2)
    %      plot(real(geom.ellipse)+scale*real(dispxy_tim), imag(geom.ellipse)+scale*imag(dispxy_tim),'k:', 'Linewidth', 2)
    %      title('Deformation of ellipse: Timoshenko test problem')
    %      legend('Undeformed shape', 'Deformed shape due to internal pressure - Fourier', 'Deformed shape due to internal pressure - Timoshenko','Location', 'NorthWest')
    %      xlabel('x')
    %      ylabel('y') 
    
    assert(allequal(disp, disp_tim, epsilon), ...
           ['displacement does not match for pressure = ' ...
            num2str(pressure) ' theta0 = ' num2str(theta0)] )
    
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


