function [cohesive, displacement, loads, potential]=finalize_timestep(stepcoh, stepdisp, stepload, steppot,cohesive, displacement, loads, potential,tt)

% This subroutine writes step quantities to global quantities at the
% end of a converged loadstep.  

loads = populate_timestep(loads, tt, stepload);
displacement = populate_timestep(displacement, tt, stepdisp);
cohesive = populate_timestep(cohesive, tt, stepcoh);
potential = populate_timestep(potential, tt, steppot);

epsilon=1e-8;
assert(allequal(loads.MacroStrain(tt,1), loads.DriverStrain(tt),epsilon), ...
       'stepload.MacroStrain has been changed!!!')



