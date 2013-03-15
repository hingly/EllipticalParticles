function make_figures_angle

close all;
%setenv("GNUTERM","x11")

colorgreen = [0, 102, 51]/255;
purple = [153, 51, 255]/255;
violet = [102, 0, 204]/255;
orange = [255, 128, 0]/255;
midgray = [160,160,160]/255;

epsilon = 1e-10;
plot_deformed_flag = false;


fignum = 0;
fignum2 = 100;



%---------------------------------
% Effect of loading angle
%----------------------------------



c1 = 20;
c2 = 100;
f = 0.4;
ratio = 0;
rationame = 'uni';
angle = 0;
aspect = 2;
lambda = 0.01;

anglelist = [0 10 20 30]*pi/180;

fignum = 1;
  
figure(fignum);
hold on;
    
for angle = anglelist

  if angle == 0
    marker = 'r*';
    marker2 = 'r*';
  elseif angle == 10*pi/180
    marker = 'b*';
    marker2 = 'b*';
  elseif angle == 20*pi/180
    marker = 'k*';
    marker2 = 'k*';
  elseif angle == 30*pi/180
    marker = 'm*';
    marker2 = 'm*';
  end
  
  if angle == 0
    datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                     num2str(aspect) '_' rationame '.dat']);
  else
    datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                     num2str(aspect) '_angle_' num2str(angle*180/pi) ...
                     '_' rationame '.dat']);
  end
  
  if exist(datafile, 'file')
    try
      data = load(datafile);
      plot(data(:,1),data(:,4), marker);
     % plot(data(:,1),data(:,2)*100, marker2, 'markersize', 2);
     % plot(data(:,1),data(:,3)*100, marker2, 'markersize', 2);  
    catch
      disp(['Empty file: ' datafile]);
    end    
  end  
end
     

fignum = 2;
fignum2 = 3;
fignum3 = 4;

    
for angle = anglelist

  if angle == 0
    marker = 'r-';
    marker2 = 'r*';
  elseif angle == 10*pi/180
    marker = 'b*';
    marker2 = 'b*';
  elseif angle == 20*pi/180
    marker = 'k*';
    marker2 = 'k*';
  elseif angle == 30*pi/180
    marker = 'm*';
    marker2 = 'm*';
  end
  
  if angle == 0
    datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                     num2str(aspect) '_' rationame '.dat']);
  else
    datafile = strcat(['Output/ellipse_c1_' num2str(c1) '_aspect_' ...
                     num2str(aspect) '_angle_' num2str(angle*180/pi) ...
                     '_' rationame '_brute.dat']);
  end
  
  if exist(datafile, 'file')
    try
      data = load(datafile);
      figure(fignum);
      hold on;
      plot(data(:,1),data(:,4), marker, 'markersize', 1, 'Linewidth', ...
           2);
      figure(fignum2);
      hold on;
      plot(data(:,1),data(:,2), marker, 'markersize', 1, 'Linewidth', ...
           2);
      figure(fignum3);
      hold on;
      plot(data(:,1),data(:,3), marker, 'markersize', 1, 'Linewidth', ...
           2);  
    catch
      disp(['Empty file: ' datafile]);
    end    
  end  
end
     


      
      
      
