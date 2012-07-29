function[material,geom,loads] = read_input(input_file)

% read an input file in JSON format using JSONlab: http://sourceforge.net/projects/iso2mesh/files/jsonlab/
% for this to work loadjson needs to be in the path

data = loadjson(input_file);
material = data.material;
geom = data.geom;
loads = data.loads;