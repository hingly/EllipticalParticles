function filename = generate_case_filename(input_case)

epsilon = 1e-5;

if abs(ratio) < epsilon
  rationame = 'uni';
elseif abs(ratio - 0.5) < epsilon
  rationame = 'half';
elseif abs(ratio - 1) < epsilon
  rationame = 'equi';
elseif abs(ratio + 0.5) < epsilon
  rationame = 'neghalf';
elseif abs(ratio + 1) < epsilon
  rationame = 'shear';  
end

filename = sprintf(['Ellipse_run/' ...
                    'ellipse_c1_%i_c2_%i_f_%i_angle_%i_aspect_%i_lambda_e_%i_ratio_%i.json'],  ...
                   c1, c2, f*100, angle*180/pi, aspect, lambda*1000, rationame);
