function [kn,kt]=old_Cohesive_law(lambda,gint,lambda_e,delopen,delslide,U)

% This function is replaced by Cohesive_Law.m  4 July 2012

% This subroutine computes kn and kt, where kn is the slope of normal
% interfacial traction and normal opening kn=S/U and kt is slope of the
% tangential interfacial traction and tangential opening kt=T/V

% The slopes of the enegy based trilinear cohesive law where kilinear is
% the initial slope and ktilde is the slope in the second stage.

klinear=2*gint/lambda_e;
ktilde=2*gint/(lambda_e-1);


% we have three different stages, which is described with an if
% statement.  When in compression, we do not allow it to fail, so we check
% this condition at the end and adjust for compression

% Note we are not accounting for unloading ****!!!!!

% We first check if the point is in the first stage


% % For linear only model
% kn=klinear/delopen^2;
% kt=klinear/delslide^2;
% 
% For nonlinear model
if lambda<=lambda_e
    kn=klinear/delopen^2;
    kt=klinear/delslide^2;
% Check for 2nd stage
elseif lambda>lambda_e && lambda<1
    kn=ktilde*(lambda-1)/lambda/delopen^2;
    kt=ktilde*(lambda-1)/lambda/delslide^2;
% Check for third stage
else
    kn=0;
    kt=0;
end

% Now we correct for compression
if U<0
    kn=klinear/delopen^2;
end
