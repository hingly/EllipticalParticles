function makefiles

epsilon = 1e-10;

%------------------------------------------------
% Loading of circle
%------------------------------------------------


fignum = 0;
c2 = 100;
f = 0.4;
angle = 0;
lambda = 0.01;
aspect = 1;

ratiolist = [0 -0.5 -1 0.5 1];
c1list = [20 50 100];
strainlist = [linspace(1,300,300)];


for ratio = ratiolist

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
  
  for c1 = c1list

    outputfile = strcat(['Output/circle_c1_' num2str(c1) '_' rationame '.dat']);
    if ~exist(outputfile, 'file')
      
      fid=fopen(outputfile,'w');
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle) '_aspect_' ...
                           num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          if ~hasfield(data.step, 'percentage')
            data.step.percentage = ...
                calculate_percentages(data.geom, data.material, ...
                                      data.step.cohesive, data.step.displacement); 
          end
          fprintf(fid, ['%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %d %d %12.5e %3.1f %3.1f %3.1f %3.1f ' ...
                         '%3.1f %3.1f %3.1f %3.1f %3.1f %3.1f \n'], ...
                  data.step.macro_var.MacroStrain, data.step.macro_var.MacroStress, ...
                  data.step.symm_error, data.converge.optim_output.iterations, ...
                  data.converge.optim_output.funcCount, data.converge.time, ...
                  data.step.percentage.undamaged, data.step.percentage.damaged, ...
                  data.step.percentage.failed, data.step.percentage.unloading,  ...
                  data.step.percentage.compression);          
        end
        
      end
      fclose(fid);
    end

  end    
end



%-----------------------------
% Uniaxial loading of ellipse
%-----------------------------

c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;

c1list = [20 50 100];
lambda = 0.01;
aspectlist = [1 2 5 10];
strainlist = [linspace(1,200,200)];

for c1 = c1list
  for aspect = aspectlist
    lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
    
    outputfile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                        num2str(aspect) '_' rationame '.dat']);
    if ~exist(outputfile, 'file')
      
      fid=fopen(outputfile,'w');
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle) '_aspect_' ...
                           num2str(aspect) lambdaname '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          if ~hasfield(data.step, 'percentage')
            data.step.percentage = ...
                calculate_percentages(data.geom, data.material, ...
                                      data.step.cohesive, data.step.displacement); 
          end
          fprintf(fid, ['%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %d %d %12.5e %3.1f %3.1f %3.1f %3.1f ' ...
                         '%3.1f %3.1f %3.1f %3.1f %3.1f %3.1f \n'], ...
                  data.step.macro_var.MacroStrain, data.step.macro_var.MacroStress, ...
                  data.step.symm_error, data.converge.optim_output.iterations, ...
                  data.converge.optim_output.funcCount, data.converge.time, ...
                  data.step.percentage.undamaged, data.step.percentage.damaged, ...
                  data.step.percentage.failed, data.step.percentage.unloading,  ...
                  data.step.percentage.compression);          
        end
        
      end
      fclose(fid);
    end
    
  end
end



%-----------------------------------------------
% Loading of an ellipse at any angle
%------------------------------------------------



c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
aspect = 2;
lambda = 0.01;

c1list = [20 50];
anglelist = [10 20 30]*pi/180;
strainlist = [linspace(1,200,200)];


for c1 = c1list
  for angle = anglelist
    lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
    
    outputfile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                        num2str(aspect) '_angle_' num2str(angle*180/pi) ...
                        '_' rationame '.dat']);

    if ~exist(outputfile, 'file')
      
      fid=fopen(outputfile,'w');
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle*180/pi) '_aspect_' ...
                           num2str(aspect) lambdaname '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          new.step.macro_var.MacroStress = stress_transformation(data.step.macro_var.MacroStress',angle);
          new.step.macro_var.MacroStrain = stress_transformation(data.step.macro_var.MacroStrain',angle);          
 
          
          if ~hasfield(data.step, 'percentage')
            data.step.percentage = ...
                calculate_percentages(data.geom, data.material, ...
                                      data.step.cohesive, data.step.displacement); 
          end
          fprintf(fid, ['%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %d %d %12.5e %3.1f %3.1f %3.1f %3.1f ' ...
                         '%3.1f %3.1f %3.1f %3.1f %3.1f %3.1f \n'], ...
                  new.step.macro_var.MacroStrain, new.step.macro_var.MacroStress,...
                  data.step.macro_var.MacroStrain, data.step.macro_var.MacroStress, ...
                  data.step.symm_error, data.converge.optim_output.iterations, ...
                  data.converge.optim_output.funcCount, data.converge.time, ...
                  data.step.percentage.undamaged, data.step.percentage.damaged, ...
                  data.step.percentage.failed, data.step.percentage.unloading,  ...
                  data.step.percentage.compression);          
        end
        
      end
      fclose(fid);
    end
    
    
  end
end

for c1 = c1list
  for angle = anglelist
    lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
    
    outputfile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                        num2str(aspect) '_angle_' num2str(angle*180/pi) ...
                        '_' rationame '_late.dat']);

    if ~exist(outputfile, 'file')
      
      fid=fopen(outputfile,'w');
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle*180/pi) '_aspect_' ...
                           num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                           rationame '_late_strain_' num2str(strain) '.json']);

        
        if exist(filename, 'file')
          data = loadjson(filename);
          new.step.macro_var.MacroStress = stress_transformation(data.step.macro_var.MacroStress',angle);
          new.step.macro_var.MacroStrain = stress_transformation(data.step.macro_var.MacroStrain',angle);          

          if ~hasfield(data.step, 'percentage')
            data.step.percentage = ...
                calculate_percentages(data.geom, data.material, ...
                                      data.step.cohesive, data.step.displacement); 
          end
          fprintf(fid, ['%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %d %d %12.5e %3.1f %3.1f %3.1f %3.1f ' ...
                         '%3.1f %3.1f %3.1f %3.1f %3.1f %3.1f \n'], ...
                  new.step.macro_var.MacroStrain, new.step.macro_var.MacroStress, ...
                  data.step.macro_var.MacroStrain, data.step.macro_var.MacroStress, ...
                  data.step.symm_error, data.converge.optim_output.iterations, ...
                  data.converge.optim_output.funcCount, data.converge.time, ...
                  data.step.percentage.undamaged, data.step.percentage.damaged, ...
                  data.step.percentage.failed, data.step.percentage.unloading,  ...
                  data.step.percentage.compression);          
        end
      end
      fclose(fid);
    end
    
  end
end




NumGuesses=5;
for c1 = c1list
  for angle = anglelist
    lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
    
    outputfile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                        num2str(aspect) '_angle_' num2str(angle*180/pi) ...
                        '_' rationame '_brute.dat']);

    if ~exist(outputfile, 'file')
      
      fid=fopen(outputfile,'w');
      
      for strain = strainlist
        for ii=1:5
          filename = strcat(['Ellipse_run/brute/ellipse_c1_' num2str(c1) ...
                             '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                             '_angle_' num2str(angle*180/pi) '_aspect_' ...
                             num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                             rationame '_strain_' num2str(strain) ...
                             '_guess_' num2str(ii) '.json']);
          
          if exist(filename, 'file')
            data = loadjson(filename);

                      if ~hasfield(data.step, 'percentage')
            data.step.percentage = ...
                calculate_percentages(data.geom, data.material, ...
                                      data.step.cohesive, data.step.displacement); 
          end
          fprintf(fid, ['%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %12.5e %12.5e %12.5e %12.5e %12.5e ' ...
                        '%12.5e %d %d %12.5e %3.1f %3.1f %3.1f %3.1f ' ...
                         '%3.1f %3.1f %3.1f %3.1f %3.1f %3.1f \n'], ...
                  new.step.macro_var.MacroStrain, new.step.macro_var.MacroStress, ...
                  data.step.macro_var.MacroStrain, data.step.macro_var.MacroStress, ...
                  data.step.symm_error, data.guess_test.optim_output.iterations, ...
                  data.guess_test.optim_output.funcCount, data.guess_test.time, ...
                  data.step.percentage.undamaged, data.step.percentage.damaged, ...
                  data.step.percentage.failed, data.step.percentage.unloading,  ...
                  data.step.percentage.compression);          
          end
         
        end
      end
      fclose(fid);
    end
    
  end
end


