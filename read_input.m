function[material, geom, loads, post] = read_input(input_file)

% read an input file in JSON format using JSONlab: http://sourceforge.net/projects/iso2mesh/files/jsonlab/
% for this to work loadjson needs to be in the path


data = loadjson(input_file);
material = data.material;
geom = data.geom;
loads = data.loads;
post = data.post;

%---------------------------------
% Check validity of input data
%=================================

check_geom(geom,loads);
check_material(material);

loads.SigmaBar1 = 1;          
%       SigmaBar1: principal applied macroscopic stress.  We never use the magnitude, so this is set to 1




