function T_Coh=Cohesive_Law(disp, NumPoints,material, lambda_max)

% This is a new function to replace the functionality of
% old_cohesivetractions.m and old_Cohesive_Law.m   ---4 July 2012



% This function computes the interfacial tractions by using the cohesive
% law.  This is done by knowing the displacement jumps and the interfacial
% properties.  The interfacial tractions are then returned.
% --- disp is the calculated displacement jumps, vector length NumPoints+1
% --- NumPoints is the number of integration points around the ellipse
% --- material is a structure containing material data
% --- lambda_max is the maximum value of lambda achieved to date, vector length NumPoints+1 

% --- delopen is the critical opening displacement (Delta n_c)
delopen=material.delopen;

% --- delslide is the critical sliding displacement (Delta t_c)
delslide=material.delslide;

% --- gint is the cohesive energy
gint=material.gint;

% --- lambda_e is the critical damage parameter
lambda_e=material.lambda_e;


% Structure of code:
   % Integration loop around particle
      % At each point, determine cohesive tractions, which requires
          % Knowing displacements, compute lambda
          % Compare lambda with lambda_max, and determine loading or unloading
          % Determine which stage of loading we are in, compute dphi/dlambda
          % Compute cohesive tractions T_Coh 
          % Do temporary store of new lambda_max where applicable.  After convergence, lambda_max gets updated

%*** If this gets called inside residual, it can't write to any values.  If it gets called from final, it can.  
% Perhaps nest inside another code which calls it with different parameters? ***


% Initialise data
T_Coh=zeros(1,NumPoints+1);
lambda_max_temp=lambda_max;        % Use lambda_max_temp to avoid overwriting previous good lambda_max 


% Integration loop around the particle to determine cohesive tractions

for jj=1:NumPoints+1
    
  loading=0;                      % Assume unloading until proven otherwise
  
  % Displacement jump
  U=real(disp(jj));
  V=imag(disp(jj));
  
  % compute damage parameter lambda
  lambda=sqrt((U/delopen)^2+(V/delslide)^2);
  
  % Compare lambda with lambda_max to see whether we are loading or unloading
  if lambda>lambda_max_temp(jj)                  % If loading
    loading=1;                                   % set loading flag to 1
    lambda_max_temp(jj)=lambda;                  % update lambda_max_temp
  end                                                
    
  %----------------------------------------------------
  % Determine the cohesive normal and tangential slopes  
  %====================================================  
  
  % Now we will compute kn and kt, where kn is the slope of normal
  % interfacial traction and normal opening kn=S/U and kt is slope of the
  % tangential interfacial traction and tangential opening kt=T/V

  
  % The slopes of the energy based trilinear cohesive law where 
  % --- kilinear is the initial slope 
  % --- ktilde is the slope in the second stage
  % --- khat is the unloading slope

  klinear=2*gint/lambda_e;                  
  ktilde=2*gint/(1-lambda_e);
  khat=ktilde*(1-lambda_max_temp(jj))/lambda_max_temp(jj);
  
  
  % Three different stages, described with an if statement.  
  
  % When in compression, we do not allow damage to advance, so we check
  % this condition at the end and adjust for compression

  % Unloading only affects the slope in Stage II.
  
  % For nonlinear model
  if lambda<=lambda_e                   % Check for Stage I
    
    kn=klinear/delopen^2;
    kt=klinear/delslide^2;
    
  elseif lambda>lambda_e && lambda<1    % Check for Stage II
    
    if loading=1                        % Check for loading
      kn=ktilde*(lambda-1)/lambda/delopen^2;
      kt=ktilde*(lambda-1)/lambda/delslide^2;
    
    else                                % unloading
      kn=khat/delopen^2;
      kt=khat/delslide^2;
    end
  
  elseif lambda>=1                      % Check for Stage III
    kn=0;
    kt=0;
  else                                  % Check for errors
    error('Incorrect value of lambda',lambda);   
  end
  
  % Now we correct for compression   **** Not sure we're doing this right!!!***
  if U<0
    kn=klinear/delopen^2;
  end
   
  % Find S,T interfacial tractions
  S=kn*U;
  T=kt*V;
  
  T_Coh(jj)=S+i*T;
end
% end of the integration loop
