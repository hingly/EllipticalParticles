function [cohesive, displacement, loads, potential]=finalize_timestep(stepcoh, stepdisp, stepload,steppot,cohesive, displacement, loads, potential,tt)

% This subroutine writes step quantities to global quantities at the
% end of a converged loadstep.  

loads.MacroStrain(tt,:)=stepload.MacroStrain(:);
loads.MacroStress(tt,:)=stepload.MacroStress(:);
loads.Sigma_m(tt,:)=stepload.Sigma_m(:);

epsilon=1e-8;
assert(allequal(loads.MacroStrain(tt,1), loads.DriverStrain(tt),epsilon), ...
       'stepload.MacroStrain has been changed!!!')






displacement.farfield(tt,:)=stepdisp.farfield(:);
displacement.farfield_xy(tt,:)=stepdisp.farfield_xy(:);
displacement.coh(tt,:)=stepdisp.coh(:);
displacement.coh_xy(tt,:)=stepdisp.coh_xy(:);
displacement.total(tt,:)=stepdisp.total(:);
displacement.total_xy(tt,:)=stepdisp.total_xy(:);


cohesive.traction(tt,:)=stepcoh.traction(:);
cohesive.traction_xy(tt,:)=stepcoh.traction_xy(:);
cohesive.lambda(tt,:)=stepcoh.lambda(:);
cohesive.lambda_xy(tt,:)=stepcoh.lambda_xy(:);
cohesive.lambda_max(tt,:)=stepcoh.lambda_max(:);
cohesive.loading(tt,:)=stepcoh.loading(:);


potential.phi(tt,:)=steppot.phi(:);
potential.phiprime(tt,:)=steppot.phiprime(:);
potential.psi(tt,:)=steppot.psi(:);
potential.phicoh(tt,:)=steppot.phicoh(:);
potential.phiprimecoh(tt,:)=steppot.phiprimecoh(:);
potential.psicoh(tt,:)=steppot.psicoh(:);


