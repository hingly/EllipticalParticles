function [default_values, variance] = scaling_values(loads, material)

default_values = nan(1, 2*loads.NumModes + 8);
variance = nan(1, 2*loads.NumModes + 8);

for ii=1:2*loads.NumModes + 5
  default_values(ii) = material.sigmax/2;
  variance(ii) = material.sigmax/2;
end

for ii = 2*loads.NumModes + 6 : 2*loads.NumModes + 8
    default_values(ii) = material.sigmax/(2*material.E_m);
    variance(ii) = material.sigmax/(2*material.E_m);
end
