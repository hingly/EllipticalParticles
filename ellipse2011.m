function [loads, macro_var, displacement, cohesive, soln]=ellipse2011(filename)

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

[loads, macro_var, soln, displacement, cohesive, potential, stepmacro_var, stepcoh] = ...
    initialize_loading(loads, geom, material);      
% Solution variables (sk, sigma_p and eps_int) are all stored in the soln structure


[cohesive, displacement, loads, macro_var, potential, soln]= ...
    loadstep_loop(geom, material, loads, macro_var, soln, displacement, cohesive, ...
                  potential, stepmacro_var, stepcoh);


% Write output data for JSON

output.cohesive = cohesive;
output.loads = loads;
output.macro_var = macro_var;
output.displacement = displacement;
output.potential = potential;
output.soln = soln;
output.material = material;
output.geom = geom;

% FIXME : use string concatenation to make appropriate output file names

json = savejson('',output,'ellipse_output.json');

