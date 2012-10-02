function full_structure = populate_timestep(full_structure, tt, timestep_structure)

for i = fieldnames(timestep_structure)'
  full_structure.(i{1})(tt, :) = timestep_structure.(i{1})(:);
end
