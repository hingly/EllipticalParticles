function [material, epsilon, NumPoints] = Cohesive_test_input

  epsilon = 1e-5;

  % FIXME : consider making these not hard-coded
  
  material.delopen = 0.5;
  material.delslide = material.delopen;
  material.sigmax = 20; 
  material.lambda_e = 0.01;
  material.gint=material.sigmax*material.delopen/2;    

  %Only 1 point around the ellipse
  NumPoints=1;



