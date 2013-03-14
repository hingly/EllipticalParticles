function [cohesive, displacement, macro_var, potential, percentage] = ...
    finalize_timestep(step, cohesive, displacement, macro_var, potential, ...
                      percentage, loads, tt)

% This subroutine writes step quantities to global quantities at the
% end of a converged loadstep.  

macro_var = populate_timestep(macro_var, tt, step.macro_var);
displacement = populate_timestep(displacement, tt, step.displacement);
cohesive = populate_timestep(cohesive, tt, step.cohesive);
potential = populate_timestep(potential, tt, step.potential);
percentage = populate_timestep(percentage,tt, step.percentage

epsilon=1e-8;
assert(allequal(macro_var.MacroStrain(tt,1), loads.DriverStrain(tt),epsilon), ...
       'step.macro_var.MacroStrain has been changed!!!')



