function [default_values, variance] = scaling_values_extra(loads, material)

default_values = nan(1, 2*loads.NumModes + 10);
variance = nan(1, 2*loads.NumModes + 10);

for ii=1:2*loads.NumModes + 6
  default_values(ii) = material.sigmax/2;
  variance(ii) = material.sigmax/2;
end

for ii = 2*loads.NumModes + 7 : 2*loads.NumModes + 9
    default_values(ii) = material.sigmax/(2*material.E_m);
    variance(ii) = material.sigmax/(2*material.E_m);
end

ii = 2*loads.NumModes + 10;
default_values(ii) = material.sigmax/2;
variance(ii) = material.sigmax/2;


