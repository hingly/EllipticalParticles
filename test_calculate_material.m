function test_calculate_material

epsilon = 1e-10;

material.plstrain = 1;
material.E_m = 1;
material.nu_m = 0.25;
material.cohscale = 1;
material.sigmax = 1;
material.delopen = 1;
material.lambda_e = 0.1;

material = calculate_material(material);

assert(allequal(material.mu_m,1/2.5, epsilon), 'Mu_m is not correct');
assert(allequal(material.lambda_m,1/2.5, epsilon), 'Lambda_m is not correct');
assert(allequal(material.kappa_m, 4, epsilon), 'Kappa_m is not correct');
assert(allequal(material.gint, 1/2, epsilon), 'Gint is not correct');
assert(allequal(material.delslide,1, epsilon), 'Delslide is not correct');



