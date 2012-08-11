function[material,geom,loads] = read_input(input_file)

% read an input file in JSON format using JSONlab: http://sourceforge.net/projects/iso2mesh/files/jsonlab/
% for this to work loadjson needs to be in the path

data = loadjson(input_file);
material = data.material;
geom = data.geom;
loads = data.loads;

if material.plstrain==0
    error('The code can only accommodate plane strain at the moment, i.e. plstrain must be 1');
end


if geom.b>geom.a
  error(['The major axis (a) must be larger than the minor axis ' ...
         '(b)']);
end

%---------------------------------------------------------
% Calculate additional material parameters
%---------------------------------------------------------



material.mu_m=material.E_m/(2*(1+material.nu_m));       
% Lame modulus
material.lambda_m= (material.E_m * material.nu_m)/((1+material.nu_m)*(1-2*material.nu_m));  
% Lame modulus

if (material.plstrain==1)
    material.kappa_m= 3+ 4*material.nu_m;
    % plane strain kappa
elseif (material.plstrain==0)
    material.kappa_m= (3-material.nu_m)/(1+material.nu_m);
    % plane stress kappa
else
    error('variable plstrain must have a value of 0 or 1')
end

material.delslide=material.cohscale*material.delopen;   
%critical sliding displacement is given by cohesive scaling parameter multiplied with critical opening displacement

material.gint=material.sigmax*material.delopen/2;       
% Cohesive energy is area under curve

loads.SigmaBar1=1;          
%       SigmaBar1: principal applied macroscopic stress.  We never use the magnitude, so this is set to 1
