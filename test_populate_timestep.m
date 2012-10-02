function test_populate_timestep

timesteps = 10;
datapoints = 20;

full_structure.a = zeros(timesteps, datapoints);
timestep_structure.a = ones(datapoints, 1);

for tt = 1:timesteps
  full_structure = populate_timestep(full_structure, tt, ...
                                     timestep_structure);
  
end

assert(full_structure.a == ones(timesteps, datapoints), ...
       'Not all datapoints were assigned')
