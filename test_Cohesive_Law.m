function test_Cohesive_Law


% FIXME : consider making these not hard-coded

material.delopen=0.5
material.delslide=0.5
material.gint=5
%corresponds to sigmax=20
material.lambda_e=0.001

NumPoints=1;
%Only 1 point around the ellipse

NumSteps=20;
% Number of steps in the displacement vector


% initialise arrays
zero_intpoints=zeros(1,NumPoints+1);
zero_stepsintpoints=zeros(NumSteps,NumPoints+1);

stepdisp=zero_intpoints;

stepcoh.traction=zero_intpoints;
stepcoh.lambda=zero_intpoints;
stepcoh.lambda_max=zero_intpoints;
stepcoh.loading=zero_intpoints;
stepcoh.lambda_max_temp=zero_intpoints;
stepcoh.loading_temp=zero_intpoints;


%--------------------------------------
% Test Mode I tension loading
%======================================



for step=1:NumSteps
  stepcoh=Cohesive_Law(stepdisp,NumPoints,material,stepcoh);
end
