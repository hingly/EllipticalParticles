function T_Coh=old_cohesivetractions(disp, NumPoints,delopen,delslide, gint,lambda_e)

% This function is replaced by Cohesive_Law.m  4 July 2012

% This function computes the interfacial tractions by using the cohesive
% law.  This is done by knowing the displacement jumps and the interfacial
% properties.  The interfacial tractions are then returned.

% Integration loop around the particle to determine the contribution of
% each points tractions to the fourier coeffients.

%*** Do we store the previous value of lambda?  How is unloading
%calculated? *** !!!!!



T_Coh=zeros(1,NumPoints+1);

for jj=1:NumPoints+1
    
    % Displacement jump
    U=real(disp(jj));
    V=imag(disp(jj));
    
    % compute damage parameter lambda
    lambda=sqrt((U/delopen)^2+(V/delslide)^2);
    
    % Determine the cohesive normal and tangential slopes
    [kn,kt]=old_Cohesive_law(lambda,gint,lambda_e,delopen,delslide,U);
    
    % Find S,T interfacial tractions
    S=kn*U;
    T=kt*V;
    
    T_Coh(jj)=S+i*T;
end
% end of the integration loop


% I don't think this is called from anywhere else so it might as
% well sit here in this function.
%    lambda=Compute_lambda(U,V,delopen,delslide);
