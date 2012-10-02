function [cohesive, displacement, macro_var, potential] = ...
    finalize_timestep(stepcoh, stepdisp, stepmacro_var, steppot, cohesive, ...
                      displacement, macro_var, loads, potential,tt)

% This subroutine writes step quantities to global quantities at the
% end of a converged loadstep.  

macro_var = populate_timestep(macro_var, tt, stepmacro_var);
displacement = populate_timestep(displacement, tt, stepdisp);
cohesive = populate_timestep(cohesive, tt, stepcoh);
potential = populate_timestep(potential, tt, steppot);

epsilon=1e-8;
assert(allequal(macro_var.MacroStrain(tt,1), loads.DriverStrain(tt),epsilon), ...
       'stepmacro_var.MacroStrain has been changed!!!')



