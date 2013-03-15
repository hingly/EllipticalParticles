function makedeformed

close all;

colorgreen = [0, 102, 51]/255;
purple = [153, 51, 255]/255;
violet = [102, 0, 204]/255;
orange = [255, 128, 0]/255;
midgray = [160,160,160]/255;

epsilon = 1e-10;
scale = 10;


%------------------------------------------------
% Loading of circle
%------------------------------------------------

%--------------------------------------------------
% Large particle size for given loading ratio
%--------------------------------------------------

fignum = 0;
c1 = 50;
c2 = 100;
f = 0.4;
angle = 0;
lambda = 0.01;
aspect = 1;


ratiolist = [0 -0.5 -1 0.5 1];
strainlist = [linspace(20,200,10)];

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
  
  figname = strcat(['Figures/circle_' rationame '_deformed.pdf']);
  if ~exist(figname, 'file')

    fignum = fignum + 1;  
    
    for strain = strainlist
      filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                         '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                         '_angle_' num2str(angle) '_aspect_' ...
                         num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                         rationame '_strain_' num2str(strain) ...
                         '.json']);
      
      if exist(filename, 'file')
        data = loadjson(filename);
        if strain == 20
          plot_geom(data, fignum, scale);
        else
          plot_deformed(data, fignum, scale);
        end
      end
      
    end

    print('-dpdf', figname);

  end    
end

  


%------------------------------------------------
% Small particle size for different aspect ratio
%------------------------------------------------

c1 = 20;
c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;

lambda = 0.01;
aspectlist = [2 5 10];
strainlist = [linspace(20,200,10)];

for aspect = aspectlist
  lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
  
  figname = strcat(['Figures/ellipse_aspect_' num2str(aspect) ...
                    '_c1_' num2str(c1) '_deformed.pdf']);

  if ~exist(figname, 'file')

    fignum = fignum + 1;  
    
    for strain = strainlist
      filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                         '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                         '_angle_' num2str(angle) '_aspect_' ...
                         num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                         rationame '_strain_' num2str(strain) ...
                         '.json']);
      
      if exist(filename, 'file')
        data = loadjson(filename);
        if strain == 20
          plot_geom(data, fignum, scale);
        else
          plot_deformed(data, fignum, scale);
        end
      end
      
    end

    
    print('-dpdf', figname);

  end
end

%------------------------------------------------
% Angle for different size particles
%------------------------------------------------

c1list = [20 50];
c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
anglelist = [5 10 20 90]*pi/180;

lambda = 0.01;
aspect = 2;
strainlist = [linspace(20,200,20)];
scale = 20;

for c1 = c1list
  for angle = anglelist
    lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
  
    figname = strcat(['Figures/ellipse_angle_' num2str(angle*180/pi) ...
                      '_c1_' num2str(c1) '_deformed.pdf']);

    if ~exist(figname, 'file')

      fignum = fignum + 1;  
    
      for strain = strainlist
        filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                           '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                           '_angle_' num2str(angle*180/pi) '_aspect_' ...
                           num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                           rationame '_strain_' num2str(strain) ...
                           '.json']);
      
        if exist(filename, 'file')
          data = loadjson(filename);
          if strain == 20
            plot_geom(data, fignum, scale);
          else
            plot_deformed(data, fignum, scale);
          end
        end
        
      end

    
      print('-dpdf', figname);
    end
  end
end




