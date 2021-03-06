function check_material(material)


assert(material.plstrain==1, ['The code can only accommodate plane ' ...
                    'strain at the moment, i.e. plstrain must be 1']); 


assert(material.nu_m < 0.5, ['Physics requires that Poissons ratio ' ...
                    'must be less than 0.5.']);

assert(material.nu_m > 0, ['Poissons ratio is greater than zero '...
                    'for most real materials.']);

assert(material.E_m > 0, ['Physics requires that Youngs modulus ' ...
                    'must be greater than zero.']);

assert(material.lambda_e < 1, ['Critical damage parameter cannot be  ' ...
                    'greater than 1']);

assert(material.lambda_e > 1e-5, ['Critical damage parameter cannot be  ' ...
                    'smaller than threshold for stability of ' ...
                    'model.']);

