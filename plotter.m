function plotter


epsilon = 1e-10;
plot_deformed_flag = false;

% Chosen parameters for testing
c1list = [20];
c2list = [100];
flist = [0.4];
aspectlist = [2];
ratiolist = [0];
anglelist = [0]*pi/180;
strainlist = [linspace(1,200,200)];
lambdalist = [0.1];

for c1 = c1list
  for c2 = c2list
    for f = flist      
      for angle = anglelist       
        for ratio = ratiolist
          
          for aspect = aspectlist
            for strain = strainlist
              for lambda = lambdalist
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
                
                if lambda == 0.1
                  lambdaname = strcat([]);
                elseif lambda == 0.01
                  lambdaname = strcat(['_lambda_e_' num2str(lambda* ...
                                                            1000)]);
                end
                
                filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                                   '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                                   '_angle_' num2str(angle) '_aspect_' ...
                                   num2str(aspect)  lambdaname '_ratio_' ...
                                   rationame '_strain_' num2str(strain) ...
                                   '.json']);
                
                data = loadjson(filename);
                data.post.scale = 10;

                if data.converge.exitflag == 1
                  if strain == 1 && angle == 0
                    if plot_deformed_flag
                      plot_geom(data);
                    end
                    plot_stress_strain_init(data);
                  else
                    plot_stress_strain(data);
                    if plot_deformed_flag
                      if mod(strain,10) == 0
                        plot_deformed(data);
                      end
                    end
                  end
                end

                
              end
            end
          end
        end
      end
    end
  end
end


