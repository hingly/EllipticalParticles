function test_read_input

epsilon = 1e-10;
% Write input file 
struct.material.plstrain = 1;
struct.material.E_m = 1;
struct.material.nu_m = 0.25;
struct.material.cohscale = 1;
struct.material.sigmax = 1;
struct.material.delopen = 1;
struct.material.lambda_e = 0.1;

struct.geom.a = 1;
struct.geom.b = 1;
struct.geom.f = 0.5;
struct.geom.NumPoints = 24;

struct.loads.NumModes = 10;
struct.loads.SigmaBarRatio = 1;
struct.loads.AppliedLoadAngle = 1;
struct.loads.timesteps = 1;
struct.loads.LoadFactor = 1;
struct.loads.MinimumStrain = 1;

struct.post.scale = 1;

filename = 'test_read.json';

json = savejson('', struct, filename);

[material, geom, loads, post] = read_input(filename);

assert(allequal(material.mu_m,1/2.5, epsilon), 'Mu_m is not correct');
assert(allequal(material.lambda_m,1/2.5, epsilon), 'Lambda_m is not correct');
assert(allequal(material.kappa_m, 4, epsilon), 'Kappa_m is not correct');
assert(allequal(material.gint, 1/2, epsilon), 'Gint is not correct');
assert(allequal(material.delslide,1, epsilon), 'Delslide is not correct');
assert(allequal(loads.SigmaBar1, 1, epsilon), 'SigmaBar1 is not correct');




error('not finished yet')