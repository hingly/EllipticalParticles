function makefigures

% makes figures by opening original step data files

close all;
setenv("GNUTERM","x11")

colorgreen = [0, 102, 51]/255;
purple = [153, 51, 255]/255;
violet = [102, 0, 204]/255;
orange = [255, 128, 0]/255;
midgray = [160,160,160]/255;

epsilon = 1e-10;
plot_deformed_flag = false;

%------------------------------------------------
% Loading of circle
%------------------------------------------------

%--------------------------------------------------
% Effect of particle size for given loading ratio
%--------------------------------------------------

fignum = 0;
fignum2 = 100;
c2 = 100;
f = 0.4;
angle = 0;
lambda = 0.01;
aspect = 1;

ratiolist = [0 -0.5 -1 0.5 1];
c1list = [20 50 100];
strainlist = [linspace(1,200,200)];


for ratio = ratiolist

  if abs(ratio) < epsilon
    rationame = 'uni';
  elseif abs(ratio - 0.5) < epsilon
    rationame = 'half';
  elseif abs(ratio - 1) < epsilon
    rationame = 'equi';
    strainlist = [linspace(1,300,300)];
  elseif abs(ratio + 0.5) < epsilon
    rationame = 'neghalf';
  elseif abs(ratio + 1) < epsilon
    rationame = 'shear';  
  end
  
  figname = strcat(['Figures/circle_' rationame '.pdf']);
  if ~exist(figname, 'file')

    fignum = fignum + 1;
    
    for c1 = c1list
      if c1 == 20
        marker = 'bo';
      elseif c1 == 50
        marker = 'ro';
      elseif c1 == 100
        marker = 'ko';
      end
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle) '_aspect_' ...
                           num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          plot_stress_strain(data, fignum, marker);          
        end
        
      end
    end

    print('-dpdf', figname);

  end    
end

  
%-------------------------------------------------
% Effect of loading ratio for given particle size
%-------------------------------------------------

for c1 = c1list
  if c1 == 20
    strainlist = [linspace(1,300,300)];
  else
    strainlist = [linspace(1,200,200)];
  end
  
  figname = strcat(['Figures/circle_c1_' num2str(c1) '.pdf']);

  if ~exist(figname, 'file')
        
    fignum = fignum + 1;
    
    for ratio = ratiolist
      
      if abs(ratio) < epsilon
        rationame = 'uni';
        marker = 'bo';
      elseif abs(ratio - 0.5) < epsilon
        rationame = 'half';
        marker = 'ro';
      elseif abs(ratio - 1) < epsilon
        rationame = 'equi';
        marker = 'ko';                
      elseif abs(ratio + 0.5) < epsilon
        rationame = 'neghalf';
        marker = 'go';
      elseif abs(ratio + 1) < epsilon
        rationame = 'shear';  
        marker = 'mo';
      end
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle) '_aspect_' ...
                           num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          plot_stress_strain(data, fignum, marker); 
        end
        
      end
    end

    print('-dpdf', figname);

  end
end

%-----------------------------
% Loading of ellipse
%-----------------------------

%----------------------------
% Effect of lambda_e
%---------------------------

c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;

c1list = [20 50 100];
lambdalist = [0.1 0.01 0.001];
aspectlist = [2 5 10];


for aspect = aspectlist
  strainlist = [linspace(1,200,200)];

  
  figname = strcat(['Figures/ellipse_lambda_aspect_' num2str(aspect) '.pdf']);
  if ~exist(figname, 'file')
    
    fignum = fignum + 1;
    
    for c1 = c1list
      for lambda = lambdalist
        
        if c1 == 20 
          if lambda == 0.1
            marker = 'bo';
          elseif lambda ==0.01
            marker = 'co';
          elseif lambda == 0.001
            marker = 'b+';
          end
        elseif c1 == 50
          if lambda == 0.1
            marker = 'ro';
          elseif lambda ==0.01
            marker = 'mo';
          elseif lambda == 0.001
            marker = 'r+';
          end
        elseif c1 == 100
          if lambda == 0.1
            marker = 'ko';
          elseif lambda ==0.01
            marker = 'go';
          elseif lambda == 0.001
            marker = 'k+';
          end
        end
        
        if lambda == 0.1
          lambdaname = strcat([]);
        else
          lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
        end
        
        
        
        for strain = strainlist
          filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                             '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                             '_angle_' num2str(angle) '_aspect_' ...
                             num2str(aspect) lambdaname '_ratio_' ...
                             rationame '_strain_' num2str(strain) ...
                             '.json']);
          
          if exist(filename, 'file')
            data = loadjson(filename);
            plot_stress_strain(data, fignum, marker);          
          end
          
        end
      end
    end
    
    print('-dpdf', figname);
    
  end
end
  
c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;

c1 = 20;
lambdalist = [0.1 0.01 0.001];
aspect = 2;
strainlist = [linspace(1,200,200)];

figname = strcat(['Figures/ellipse_lambda_effect.pdf']);
if ~exist(figname, 'file')
  
  fignum = fignum + 1;
     
  for lambda = lambdalist

    if lambda == 0.1
      lambdaname = strcat([]);
    else
      lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
    end    
        
    if lambda == 0.1 
      marker = 'ro';
    elseif lambda == 0.01
      marker = 'bo';
    elseif lambda == 0.001
      marker = 'ko';
    end
    
    for strain = strainlist
      filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                         '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                         '_angle_' num2str(angle) '_aspect_' ...
                         num2str(aspect) lambdaname '_ratio_' ...
                         rationame '_strain_' num2str(strain) ...
                         '.json']);
      
      if exist(filename, 'file')
        data = loadjson(filename);
        plot_stress_strain(data, fignum, marker);          
      end
      
    end
  end
  print('-dpdf', figname);
end



%------------------------------------------------
% Effect of aspect ratio for given particle size
%------------------------------------------------


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
  lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
  
  figname = strcat(['Figures/ellipse_aspect_c1_' num2str(c1) ...
                    '.pdf']);
  if ~exist(figname, 'file')
    
    fignum = fignum + 1;
    
    for aspect = aspectlist
      
      if aspect == 1 
        marker = 'mo';
      elseif aspect == 2
        marker = 'ro';
      elseif aspect == 5
        marker = 'ko';
      elseif aspect == 10
        marker = 'bo';
      end
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle) '_aspect_' ...
                           num2str(aspect) lambdaname '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          plot_stress_strain(data, fignum, marker);          
        end
        
      end
    end
    
    print('-dpdf', figname);

  end
end


%-----------------------------------------------
% Effect of particle size for given aspect ratio
%------------------------------------------------

c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;

c1list = [20 50 100];
lambda = 0.01;
aspectlist = [1 2 5 10];
strainlist = [linspace(1,200,200)];

for aspect = aspectlist

  lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);

  figname = strcat(['Figures/ellipse_size_aspect_' num2str(aspect) '.pdf']);
  if ~exist(figname, 'file')
    
    fignum = fignum + 1;
    
    for c1 = c1list
      
      if c1 == 20
        marker = 'ro';
      elseif c1 == 50
        marker = 'ko';
      elseif c1 == 100
        marker = 'bo';
      end
      
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle) '_aspect_' ...
                           num2str(aspect) lambdaname '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
        
        if exist(filename, 'file')
          data = loadjson(filename);
          plot_stress_strain(data, fignum, marker);          
        end
        
      end
    end
    
    print('-dpdf', figname);

  end
end






%-----------------------------------------------
% Effect of loading angle
%------------------------------------------------

c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;
aspect = 2;
lambda = 0.01;

c1list = [20 50];
strainlist = [linspace(1,200,200)];
anglelist = [0 10 20 30]*pi/180;
%anglelist = [90]*pi/180;

for c1 = c1list
  lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
  
  figname = strcat(['Figures/ellipse_angle_c1_' num2str(c1) ...
                    '.pdf']);
  
  if ~exist(figname, 'file')
    
    fignum = fignum + 1;
    
    for angle = anglelist
      
      if angle == 0
        marker = 'ro';
        marker2 = 'r*';
      elseif angle == 5*pi/180
        marker = 'co';
        marker2 = 'c*';
      elseif angle == 10*pi/180
        marker = 'bo';
        marker2 = 'b*';
      elseif angle == 15*pi/180
        marker = 'go';
        marker2 = 'g*';
      elseif angle == 20*pi/180
        marker = 'ko';
        marker2 = 'k*';
      elseif angle == 30*pi/180
        marker = 'mo';
        marker2 = 'm*';
      end
      
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
          plot_stress_strain(new, fignum, marker);          
        end
        
        filename2 = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                            '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                            '_angle_' num2str(angle*180/pi) '_aspect_' ...
                            num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                            rationame '_late' '_strain_' ...
                            num2str(strain) '.json']);
        if exist(filename2, 'file')
          data = loadjson(filename2);
          new.step.macro_var.MacroStress = stress_transformation(data.step.macro_var.MacroStress',angle);
          new.step.macro_var.MacroStrain = stress_transformation(data.step.macro_var.MacroStrain',angle);          
          plot_stress_strain(new, fignum, marker2);          
        end
        
        
      end
    end
    
    print('-dpdf', figname);

  end
end

%------------------------------
% Brute force loading angle
%------------------------------

c2 = 100; 
ratio = 0;
rationame = 'uni';
f = 0.4;
aspect = 2;
lambda = 0.01;
NumGuesses = 5;

c1list = [20 50];
anglelist = [10 20 30]*pi/180;

strainlist = [linspace(1, 200, 200)];


for c1 = c1list
  
  lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
  figname = strcat(['Figures/ellipse_angle_c1_' num2str(c1) ...
                    '_brute.pdf']);
  figname2 = strcat(['Figures/ellipse_angle_c1_' num2str(c1) ...
                    '_brute_unrotated.pdf']);
  
  if ~exist(figname, 'file')
    
    fignum = fignum + 1;
    fignum2 = fignum2 + 1;
    
  
    for angle = anglelist  

      if angle == 0
        marker = 'mo';
      elseif angle == 5*pi/180
        marker = 'co';
      elseif angle == 10*pi/180
        marker = 'bo';
      elseif angle == 15*pi/180
        marker = 'go';
      elseif angle == 20*pi/180
        marker = 'ro';        
      elseif angle == 30*pi/180
        marker = 'ko';
      end

      for strain = strainlist
        for ii = 1:NumGuesses

          filename = strcat(['Ellipse_run/brute/ellipse_c1_' num2str(c1) ...
                             '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                             '_angle_' num2str(angle*180/pi) '_aspect_' ...
                             num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                             rationame  '_strain_' num2str(strain) '_guess_' num2str(ii) '.json']);

          if exist(filename, 'file')
            data = loadjson(filename);
            new.step.macro_var.MacroStress = stress_transformation(data.step.macro_var.MacroStress',angle);
            new.step.macro_var.MacroStrain = stress_transformation(data.step.macro_var.MacroStrain',angle);          
            plot_stress_strain(new, fignum, marker);                      
            plot_stress_strain(data, fignum2, marker);  
          end
        end
      end
    end 
    figure(fignum);
    axis([0 2 0 1.5]);
    print(fignum,'-dpdf', figname);
    figure(fignum2);
    axis([0 2 0 1.5]);
    print(fignum2,'-dpdf', figname2);
  end
end
