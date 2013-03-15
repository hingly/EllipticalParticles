function ellipse2011(inputname)

if ~exist('inputname', 'var')
  inputname=input('Enter the input filename including path (excluding .json): ','s');
end

if regexp(inputname, '\.json$')
  inputname = inputname(1:end-5);
end

filename = [inputname '.json'];

if ~exist(inputname, 'dir')
  mkdir(inputname);
end

outputname = [inputname '/output.json'];

datestring = clock;
disp([num2str(datestring(4)) ':' num2str(datestring(5)) ' on ' ...
      num2str(datestring(3)) '/' num2str(datestring(2)) '/' num2str(datestring(1)) ]);

% This is the main driver code in the new improved 2011 version of the ellipse code.  

%------------------------------------------------------------------
% Read input data and create structures for main variables
%==================================================================

[material, geom, loads, post] = read_input(filename);

%---------------------------------------------------------
% Calculate additional material parameters
%---------------------------------------------------------

material = calculate_material(material);

%------------------------------------------------------------------
% Calculate positions and angles at each point around the ellipse
%==================================================================

geom = calculate_geometry(geom);

%------------------------------------------------------------------
% Initialize global variables
%==================================================================

[loads, macro_var, displacement, cohesive, potential, percentage, soln] = ...
    initialize_global_variables(loads, geom, material);   

% Calculate stress ratios for imposed stress
loads = calculate_imposed_stress(loads);

% Solution variables (sk, sigma_p and eps_int) are all stored in
% the soln structure. Guess for the first timestep
soln = first_guess_soln(loads, material, geom, soln);


% Loop through loadsteps
[cohesive, displacement, loads, macro_var, potential, percentage, soln]= ...
    loadstep_loop(geom, material, loads, macro_var, soln, displacement, cohesive, ...
                  potential, percentage, inputname);


% Write output data for JSON


output.cohesive = cohesive;
output.loads = loads;
output.macro_var = macro_var;
output.displacement = displacement;
output.potential = potential;
output.percentage = percentage;
output.soln = soln;
output.material = material;
output.geom = geom;

json = savejson('',output,outputname);

