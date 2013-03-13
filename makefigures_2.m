function makefigures_2

close all;
setenv("GNUTERM","x11")

colorgreen = [0, 102, 51]/255;
purple = [153, 51, 255]/255;
violet = [102, 0, 204]/255;
orange = [255, 128, 0]/255;
midgray = [160,160,160]/255;

epsilon = 1e-10;
plot_deformed_flag = false;


fignum = 0;
fignum2 = 100;

%------------------------------------------------
% Loading of circle
%------------------------------------------------

%--------------------------------------------------
% Effect of particle size for given loading ratio
%--------------------------------------------------

c2 = 100;
f = 0.4;
angle = 0;
lambda = 0.01;
aspect = 1;

ratiolist = [-1 -0.5 0 0.5 1];
c1list = [20 50 100];


for ratio = ratiolist

  if abs(ratio) < epsilon
    rationame = 'uni';
    axissize=[0 2 0 1.2];
  elseif abs(ratio - 0.5) < epsilon
    rationame = 'half';
    axissize=[0 2 0 1.2];
  elseif abs(ratio - 1) < epsilon
    rationame = 'equi';
    axissize=[0 3 0 1.2];
  elseif abs(ratio + 0.5) < epsilon
    rationame = 'neghalf';
    axissize=[0 2 0 1.2];
  elseif abs(ratio + 1) < epsilon
    rationame = 'shear';  
    axissize=[0 2 0 1.2];
  end
  
  figname = strcat(['Figures/circle_' rationame '_collated']);
  fignamepdf = strcat([figname '.pdf']); 
  fignamefig = strcat([figname '.fig']); 
  if ~exist(fignamepdf, 'file')

    fignum = fignum + 1;
    
    figure(fignum);
    hold on;
    
    for c1 = c1list
      if c1 == 20
        marker = 'b-';
      elseif c1 == 50
        marker = 'r-';
      elseif c1 == 100
        marker = 'k-';
      end
     
      datafile = strcat(['Output/circle_c1_' num2str(c1) '_' rationame '.dat']);
     
      if exist(datafile, 'file')
        try
          data = load(datafile);
          plot(data(:,1)*100,data(:,4), marker);
        catch
          disp(['Empty file: ' datafile]);
        end    

      end
    end
    axis(axissize);
    ylabel('Normalised macroscopic stress   \sigma_{11}/\sigma_{max}')
    xlabel('Macroscopic strain   \epsilon_{11} [%]');
    legend('a/\Delta n_c = 20  ', 'a/\Delta n_c = 50  ', 'a/\Delta n_c = 100');
    print('-dpdf', fignamepdf);
    print('-dfig', fignamefig);   

  end    
end

  
%-------------------------------------------------
% Effect of loading ratio for given particle size
%-------------------------------------------------

for c1 = c1list
  
  figname = strcat(['Figures/circle_c1_' num2str(c1) '_collated']);
  fignamepdf = strcat([figname '.pdf']); 
  fignamefig = strcat([figname '.fig']); 
  
  if ~exist(fignamepdf, 'file')
        
    fignum = fignum + 1;
    
    figure(fignum);
    hold on;
    
    if c1 == 20
      axissize=[0 3 0 1.2];
    else
      axissize=[0 2 0 1.2];
    end
    
    
    for ratio = ratiolist
      
      if abs(ratio) < epsilon
        rationame = 'uni';
        marker = 'b';
      elseif abs(ratio - 0.5) < epsilon
        rationame = 'half';
        marker = 'r';
      elseif abs(ratio - 1) < epsilon
        rationame = 'equi';
        marker = 'k';                
      elseif abs(ratio + 0.5) < epsilon
        rationame = 'neghalf';
        marker = 'g';
      elseif abs(ratio + 1) < epsilon
        rationame = 'shear';  
        marker = 'm';
      end
      
      datafile = strcat(['Output/circle_c1_' num2str(c1) '_' rationame '.dat']);
     
      if exist(datafile, 'file')
        data = load(datafile);
        plot(data(:,1)*100,data(:,4), marker, "Linewidth", 3, "linestyle",'--');
      end
    end
    ylabel('Normalised macroscopic stress   \sigma_{11}/\sigma_{max}')
    xlabel('Macroscopic strain   \epsilon_{11} [%]');
    legend('\sigma_2 = - \sigma_1     ', '\sigma_2 = -1/2 \sigma_1', '\sigma_2 = 0         ', ...
           '\sigma_2 = 1/2 \sigma_1 ', '\sigma_2 = \sigma_1       ');
    axis(axissize);
    print('-dpdf', fignamepdf);
    print('-dfig', fignamefig);
  end
end



%-----------------------------
% Loading of ellipse
%-----------------------------




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
  figname = strcat(['Figures/ellipse_aspect_c1_' num2str(c1) ...
                    '_collated']);
  fignamepdf = strcat([figname '.pdf']); 
  fignamefig = strcat([figname '.fig']); 
  if ~exist(fignamepdf, 'file')
    
    fignum = fignum + 1;

    figure(fignum);
    hold on;    
    for aspect = aspectlist
      
      if aspect == 1 
        marker = 'm';
      elseif aspect == 2
        marker = 'r';
      elseif aspect == 5
        marker = 'k';
      elseif aspect == 10
        marker = 'b';
      end

      datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                        num2str(aspect) '_' rationame '.dat']);
     
      if exist(datafile, 'file')
        data = load(datafile);
        plot(data(:,1)*100,data(:,4), marker, "Linewidth", 3, "linestyle",'--');
      end  

    end
    ylabel('Normalised macroscopic stress   \sigma_{11}/\sigma_{max}')
    xlabel('Macroscopic strain   \epsilon_{11} [%]');
    legend('a/b = 1  ', 'a/b = 2  ', 'a/b = 5  ', 'a/b = 10');
%    axis([0 2 0 1.2])

    print('-dpdf', fignamepdf);
    print('-dfig', fignamefig);

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
aspectlist = [2 5 10];
strainlist = [linspace(1,200,200)];

for aspect = aspectlist

  figname = strcat(['Figures/ellipse_size_aspect_' num2str(aspect) '_collated']);
  fignamepdf = strcat([figname '.pdf']); 
  fignamefig = strcat([figname '.fig']); 
  
  if ~exist(fignamepdf, 'file')
    
    fignum = fignum + 1;
    figure(fignum);
    hold on;
    
    for c1 = c1list
      
      if c1 == 20
        marker = 'r';
      elseif c1 == 50
        marker = 'k';
      elseif c1 == 100
        marker = 'b';
      end
      
      datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                        num2str(aspect) '_' rationame '.dat']);
     
      if exist(datafile, 'file')
        data = load(datafile);
        plot(data(:,1)*100,data(:,4), marker, "Linewidth", 3, "linestyle",'--');
      end  

    end
    ylabel('Normalised macroscopic stress   \sigma_{11}/\sigma_{max}')
    xlabel('Macroscopic strain   \epsilon_{11} [%]');
    legend('a/\Delta n_c = 20  ', 'a/\Delta n_c = 50  ', 'a/\Delta n_c = 100');
    print('-dpdf', fignamepdf);
    print('-dpdf', fignamefig);

  end
end




%---------------------------------
% Effect of loading angle
%----------------------------------




c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;
aspect = 2;
lambda = 0.01;

c1list = [20 50];
anglelist = [0 10 20 30]*pi/180;

for c1 = c1list
  lambdaname = strcat(['_lambda_e_' num2str(lambda*1000)]);
  
  figname = strcat(['Figures/ellipse_angle_c1_' num2str(c1) ...
                    '_collated']);
  fignamepdf = strcat([figname '.pdf']); 
  fignamefig = strcat([figname '.fig']); 
  
  if ~exist(fignamepdf, 'file')
    
    fignum = fignum + 1;
  
    figure(fignum);
    hold on;
    
    for angle = anglelist

      if angle == 0
        marker = 'r-';
        marker2 = 'r*';
      elseif angle == 10*pi/180
        marker = 'b-';
        marker2 = 'bo';
      elseif angle == 20*pi/180
        marker = 'k-';
        marker2 = 'ko';
      elseif angle == 30*pi/180
        marker = 'm-';
        marker2 = 'mo';
      end
      
      datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                         num2str(aspect) '_angle_' num2str(angle*180/pi) ...
                         '_' rationame '.dat']);
      if exist(datafile, 'file')
        try
          data = load(datafile);
          plot(data(:,1),data(:,4), marker2);
        catch
          disp(['Empty file: ' datafile]);
        end    
       

      end
     
    end
    print('-dpdf', fignamepdf);
    print('-dfig', fignamefig); 
  end
end

      
      
      
      
