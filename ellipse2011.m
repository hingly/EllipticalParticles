function ellipse2011(filename)

if ~exist('filename', 'var')
  filename=input('Enter the complete input filename: ','s');
end

% This is going to be the main driver code in the new improved 2011
% version of the ellipse code.  
% Hoorah!


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

[loads,soln,stepload]=initialize_loading(loads,geom);      
% Solution variables (sk, sigma_p and eps_int) are all stored in the soln structure


%-----------------------------------------
% Begin loop through loadsteps
%=========================================


for tt=1:loads.timesteps  % Loop through loading steps
  
% FIXME : ****  Notice: need to check that everything is getting
  %initialised/reset properly here! ****

% FIXME : *** These should really be using the previous timestep value as a first guess
  
  if tt>1
    [soln, stepload] = incorporate_previous_timestep(soln, material, loads, tt);
  end
  
  % The complex fourier terms are  split into real and imaginary 
  % parts before going into the solution loop.  
  
  input=stack(soln,loads.NumModes,tt);
  
  exitflag=0;
  counter=0;
  
  while exitflag<=0                    
    % Convergence loop
    
    counter=counter+1;
    
    %****  Notice: need to check that everything is getting
    %initialised/reset properly here! ****
    
    
    
    % Solve for sk, Sigma_p, Eps_int
    %       options=optimset('Display','iter', 'TolFun',1e-5,
    %       'MaxFunEvals', 5000, 'MaxIter', 60);    % Option to display output
    [output,fval,exitflag]=fsolve(@(input) residual(input, steploads,loads, material, geom),input);
    
    
    if exitflag<=0
      if counter>2
        error('Non-converged solution')
      else
        for kk=1:2*loads.NumModes+8
          input(kk)=output(kk)*(1+rand/100);
        end
      end
    end
  
  end
  % end convergence loop
  
  soln=unstack(output,loads.NumModes,tt);
  
  % | | | |
  % v v v v
  
% FIXME : write steploads to loads and generally tidy up at the end of converged step *** This includes all the following!!!
  
  % Write lambda_max_temp to lambda_max
  loads.lambda_max(tt,:) = lambda_max_temp;             

% FIXME : Should this overwriting happen in final.m?  Should I do
  % a comparison check or just copy over?  Not sure lambda_max_temp
  % is actually available as a variable in this routine
  
% THINK : decide whether to allow load/unload decision in cohesive
% subroutine, or set at the end of previous step.  
  
  % ^ ^ ^ ^
  % | | | |
  

  [stepcoh, stepdisp, stepload]=final(soln, loads, material, geom);

  [cohesive, disp, loads]=finalize_timestep(stepcoh, stepdisp, stepload, tt)

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



% $$$ figure
% $$$ axis equal;
% $$$ hold on;
% $$$ plot(ellipse(1,:),ellipse(2,:), 'LineWidth', 2);
% $$$ plot(ellipse(1,:)+scale*real(dispxy), ellipse(2,:)+scale*imag(dispxy),'r', 'Linewidth', 2)
% $$$ plot(ellipse(1,:)+scale*real(dispffxy), ellipse(2,:)+scale*imag(dispffxy),'k:')
% $$$ legend('Undeformed shape', 'Total Deformed Shape','Deformed shape due to far-field loading','Location', 'NorthWest')
% $$$ xlabel('x')
% $$$ ylabel('y')
% $$$ 
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
% figure2
% hold on
% plot(macstrain(:,1), macstress(:,1), 'bx-', 'LineWidth', 2)
% title('Macroscopic constitutive response - 11')
% xlabel('strain')
% ylabel('stress')
% 
% figure2
% hold on
% plot(macstrain(:,2), macstress(:,2), 'rx-', 'LineWidth', 2)
% title('Macroscopic constitutive response - 22')
% xlabel('strain')
% ylabel('stress')
% 
% figure2
% hold on
% plot(macstrain(:,3), macstress(:,3), 'kx-', 'LineWidth', 2)
% title('Macroscopic constitutive response - 33')
% xlabel('strain')
% ylabel('stress')



