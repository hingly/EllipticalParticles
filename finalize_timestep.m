function [cohesive, disp, loads]=finalize_timestep(stepcoh, stepdisp, stepload,tt)

if loads.MacroStrain(tt,1)=stepload.MacroStrain(1)
  loads.MacroStrain(tt,:)=stepload.MacroStrain(:);
else
  error('stepload.MacroStrain has been changed!!!');
end

loads.MacroStress(tt,:)=stepload.MacroStress(:);
loads.Sigma_m(tt,:)=stepload.Sigma_m(:);

disp.farfield(tt,:)=stepdisp.farfield(:);
disp.farfield_xy(tt,:)=stepdisp.farfield_xy(:);
disp.coh(tt,:)=stepdisp.coh(:);
disp.coh_xy(tt,:)=stepdisp.coh_xy(:);
disp.total(tt,:)=stepdisp.total(:);
disp.total_xy(tt,:)=stepdisp.total_xy(:);

coh.traction(tt,:)=stepcoh.traction(:);
coh.traction_xy(tt,:)=stepcoh.traction_xy(:);
coh.lambda(tt,:)=stepcoh.lambda(:);
coh.lambda_xy(tt,:)=stepcoh.lambda_xy(:);
coh.lambda_max(tt,:)=stepcoh.lambda_max(:);
coh.loading(tt,:)=stepcoh.loading(:);

