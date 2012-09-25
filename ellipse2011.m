function [loads, displacement, cohesive, soln]=ellipse2011(filename)

if ~exist('filename', 'var')
  filename=input('Enter the complete input filename: ','s');
end

% This is the main driver code in the new improved 2011 version of the ellipse code.  

%------------------------------------------------------------------
% Read input data and create structures for main variables
%==================================================================

[material,geom,loads, post] = read_input(filename);


%---------------------------------------------------------
% Calculate additional material parameters
%---------------------------------------------------------

material = calculate_material(material);

%------------------------------------------------------------------
% Calculate positions and angles at each point around the ellipse
%==================================================================

geom=calculate_geometry(geom);

%------------------------------------------------------------------
% Calculate loading variables
%==================================================================

[loads,soln,displacement,cohesive,potential,stepload,stepcoh]=initialize_loading(loads,geom,material);      
% Solution variables (sk, sigma_p and eps_int) are all stored in the soln structure


[cohesive, displacement, loads, potential, soln]= ...
    loadstep_loop(geom, material, loads, soln, displacement, cohesive, ...
                  potential,stepload,stepcoh);


% Write output data for JSON

output.cohesive = cohesive;
output.loads = loads;
output.displacement = displacement;
output.potential = potential;
output.soln = soln;
output.material = material;
output.geom = geom;

% FIXME : use string concatenation to make appropriate output file names

json = savejson('',output,'ellipse_output.json');

