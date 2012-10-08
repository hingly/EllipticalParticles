function displacement = ...
    check_displacement_uniaxial_circle(mu, kappa, a, theta)

sigma = exp(i*theta);
coefficient = a*(kappa + 1)/(4*mu);

displacement1 = 1/2;
displacement2 = 1/sigma^2;

displacement = coefficient * (displacement1 + displacement2);


