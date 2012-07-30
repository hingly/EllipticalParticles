function [loads, displacement, cohesive, soln]=ellipse2011(filename)

if ~exist('filename', 'var')
  filename=input('Enter the complete input filename: ','s');
end

% This is the main driver code in the new improved 2011 version of the ellipse code.  


%------------------------------------------------------------------
% Read input data and create structures for main variables
%==================================================================

[material,geom,loads] = read_input(filename);

%------------------------------------------------------------------
% Calculate positions and angles at each point around the ellipse
%==================================================================

geom=calculate_geometry(geom);

%------------------------------------------------------------------
% Calculate loading variables
%==================================================================

[loads,soln,displacement,cohesive,potential,stepload,stepcoh]=initialize_loading(loads,geom,material);      
% Solution variables (sk, sigma_p and eps_int) are all stored in the soln structure


%-----------------------------------------
% Begin loop through loadsteps
%=========================================


for tt=1:loads.timesteps  % Loop through loading steps
  
% FIXME : ****  Notice: need to check that everything is getting
  %initialised/reset properly here! ****
  
  disp('Beginning timestep...');
  loads.MacroStrain(tt,1)
  
  if tt>1
    [soln, stepload,stepcoh] = incorporate_previous_timestep(soln, material, loads, cohesive,tt);
  end
  
  % The complex fourier terms are  split into real and imaginary 
  % parts before going into the solution loop.  
  
  input_guess=stack(soln,loads.NumModes,tt);
  
  exitflag=0;
  counter=0;
  
  while exitflag<=0                    
    % Convergence loop
    
    counter=counter+1;
    
    %****  Notice: need to check that everything is getting
    %initialised/reset properly here! ****
    
    
    
    % Solve for sk, Sigma_p, Eps_int
   % options=optimset('Display','iter', 'TolFun',1e-5, 'MaxFunEvals', 5000, 'MaxIter', 60);    % Option to display output

%    [output,fval,exitflag]=fsolve(@(input_guess) residual(input_guess, stepload,loads, material, geom,stepcoh),input_guess,options);
    
    [output,fval,exitflag]=fsolve(@(input_guess) residual(input_guess, stepload,loads, material, geom,stepcoh),input_guess);
    
    if exitflag<=0
      if counter>2
        error('Non-converged solution')
      else
        for kk=1:2*loads.NumModes+8
          input_guess(kk)=output(kk)*(1+rand/100);
        end
      end
    end
  
  end
  % end convergence loop
  
  soln=unstack(output,loads.NumModes,tt,soln);

  % Calculate final values based on converged sk, sigma_p and eps_int
  [stepcoh, stepdisp, stepload, steppot]=final(soln, stepload,loads, material, geom,stepcoh,tt);

  % Write final step values to global values
  [cohesive, displacement, loads, potential]=finalize_timestep(stepcoh, stepdisp, stepload, steppot, cohesive, displacement, loads, potential,tt);

% FIXME : finalize_timestep.m could be inside final.m

  


  %     figure(1)
  %     hold on;
  %     plot(macstrain(tt,1), macstress(tt,1), 'rx')
  
% $$$ outputstep=1;   % how often to output displaced shape
% $$$ 
% $$$     if mod(tt,outputstep)==0
% $$$         figure2
% $$$         axis equal;
% $$$         hold on;
% $$$         plot(ellipse(1,:),ellipse(2,:), 'LineWidth', 2);
% $$$         plot(ellipse(1,:)+scale*real(dispxy), ellipse(2,:)+scale*imag(dispxy),'r', 'Linewidth', 2)
% $$$         plot(ellipse(1,:)+scale*real(dispffxy), ellipse(2,:)+scale*imag(dispffxy),'k:')
% $$$         legend('Undeformed shape', 'Total Deformed Shape','Deformed shape due to far-field loading','Location', 'NorthWest')
% $$$         xlabel('x')
% $$$         ylabel('y')
% $$$ 
% $$$ 
% $$$         figure2
% $$$         axis equal;
% $$$         hold on;
% $$$         plot(ellipse(1,:),ellipse(2,:));
% $$$         plot(ellipse(1,:)+real(lambdaxy), ellipse(2,:)+imag(lambdaxy),'r', 'Linewidth', 2)
% $$$         plot(ellipse(1,:)+real(xy1), ellipse(2,:)+imag(xy1),'k')
% $$$         title('Distribution of damage parameter lambda around the ellipse.')
% $$$         legend('Lambda=0', 'Lambda','Lambda=1','Location', 'NorthWest')
% $$$         xlabel('x')
% $$$         ylabel('y')
% $$$     end
% $$$     
% $$$     sprintf('Macroscopic strain is %12.5e  %12.5e %12.5e', macstrain(tt,:))
% $$$     sprintf('Macroscopic stress is %12.5e  %12.5e %12.5e', macstress(tt,:))
% $$$         
% $$$     fprintf(stresstable, '%12.5e  %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e %12.5e \n', macstrain(tt,:), macstress(tt,:), sigmap(tt,:), sigmam(tt,:), epsint(tt,:));
% $$$   

end      % end loop through loading steps



%figure(1)
%axis equal;
%hold on;
%plot(geom.ellipse(1,:),geom.ellipse(2,:), 'LineWidth', 2);
%plot(geom.ellipse(1,:)+post.scale*real(displacement.total_xy), geom.ellipse(2,:)+post.scale*imag(displacement.total_xy),'r', 'Linewidth', 2);
%plot(geom.ellipse(1,:)+post.scale*real((displacement.farfield_xy), geom.ellipse(2,:)+post.scale*imag(displacement.farfield_xy),'k:');
%legend('Undeformed shape', 'Total Deformed Shape','Deformed shape due to far-field loading','Location', 'NorthWest')
%xlabel('x')
%ylabel('y')

% $$$ 
% $$$ figure
% $$$ axis equal;
% $$$ hold on;
% $$$ plot(ellipse(1,:),ellipse(2,:));
% $$$ plot(ellipse(1,:)+real(lambdaxy), ellipse(2,:)+imag(lambdaxy),'r', 'Linewidth', 2)
% $$$ plot(ellipse(1,:)+real(xy1), ellipse(2,:)+imag(xy1),'k')
% $$$ title('Distribution of damage parameter lambda around the ellipse.  Lambda=0 indicates no damage (or compression), lambda=1 indicates complete failure')
% $$$ legend('Lambda=0', 'Lambda','Lambda=1','Location', 'NorthWest')
% $$$ xlabel('x')
% $$$ ylabel('y')
% 

% $$$ figure(2)
% $$$ hold on
% $$$ plot(loads.MacroStrain(:,1), loads.MacroStress(:,1), 'bx-', 'LineWidth', 2)
% $$$ title('Macroscopic constitutive response - 11')
% $$$ xlabel('strain')
% $$$ ylabel('stress')
 
% $$$  hold on
% $$$  plot(loads.MacroStrain(:,2), loads.MacroStress(:,2), 'rx-', 'LineWidth', 2)
% $$$  title('Macroscopic constitutive response - 22')
% $$$  xlabel('strain')
% $$$  ylabel('stress')
% $$$ 
% $$$  hold on
% $$$  plot(loads.MacroStrain(:,3), loads.MacroStress(:,3), 'kx-', 'LineWidth', 2)
% $$$  title('Macroscopic constitutive response - 33')
% $$$  xlabel('strain')
% $$$  ylabel('stress')
% $$$ 