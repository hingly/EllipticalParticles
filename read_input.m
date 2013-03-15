function[material, geom, loads] = read_input(input_file)

% read an input file in JSON format using JSONlab: http://sourceforge.net/projects/iso2mesh/files/jsonlab/
% for this to work loadjson needs to be in the path


data = loadjson(input_file);
material = data.material;
geom = data.geom;
loads = data.loads;

%---------------------------------
% Check validity of input data
%=================================

check_geom(geom,loads);
check_material(material);

loads.SigmaBar1 = 1;          
%       SigmaBar1: principal applied macroscopic stress.  We never
%       use the magnitude, so this is set to 1


%---------------------------------------------------------
% Calculate additional material parameters
%---------------------------------------------------------

material = calculate_material(material);

%------------------------------------------------------------------
% Calculate positions and angles at each point around the ellipse
%==================================================================

geom = calculate_geometry(geom);
