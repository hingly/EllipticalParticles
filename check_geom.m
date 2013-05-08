function check_geom(geom, loads)



assert(geom.b<=geom.a, ['The major axis (a) must be larger than ' ...
                    'the minor axis (b)']); 

assert(mod(loads.NumModes,2)==0,...
       'NumModes must be an even number');

assert(mod(geom.NumPoints,2)==0,...
       'NumPoints must be an even number');

assert(geom.NumPoints>loads.NumModes, ['NumPoints must be bigger ' ...
                    'than NumModes']);

assert(geom.f <= 1, 'Cannot have volume fraction bigger than 1');

assert(geom.f >= 0, 'Cannot have volume fraction smaller than 0');

assert(loads.MinimumStrain >=0.0001, ['Minimum Strain smaller than ' ...
                    '0.0001 will break the output structure --- may ' ...
                    'need some recoding']);



% FIXME : move NumPoints from geom to loads and have a separate
% check_loads file.
